    /* 

    Monte Carlo Hackathon created by Hafsa Demnati and Patrick Demichel @ Viridien 2024
    The code compute a Call Option with a Monte Carlo method and compare the result with the analytical equation of Black-Scholes Merton : more details in the documentation

    Compilation : g++ -O BSM.cxx -o BSM

    Exemple of run: ./BSM #simulations #runs

./BSM 100 1000000
Global initial seed: 21852687      argv[1]= 100     argv[2]= 1000000
 value= 5.136359 in 10.191287 seconds

./BSM 100 1000000
Global initial seed: 4208275479      argv[1]= 100     argv[2]= 1000000
 value= 5.138515 in 10.223189 seconds
 
   We want the performance and value for largest # of simulations as it will define a more precise pricing
   If you run multiple runs you will see that the value fluctuate as expected
   The large number of runs will generate a more precise value then you will converge but it require a large computation

   give values for ./BSM 100000 1000000        
               for ./BSM 1000000 1000000
               for ./BSM 10000000 1000000
               for ./BSM 100000000 1000000
  
   We give points for best performance for each group of runs 

   You need to tune and parallelize the code to run for large # of simulations

*/



















#include <iostream>
#include <cmath>
#include <random>
#include <boost/random/mersenne_twister.hpp>
#include <boost/random/normal_distribution.hpp>
#include <boost/random/variate_generator.hpp>

#include <vector>
#include <limits>
#include <algorithm>
#include <iomanip>   // For setting precision

#define ui64 u_int64_t

#include <sys/time.h>
double
dml_micros()
{
        static struct timezone tz;
        static struct timeval  tv;
        gettimeofday(&tv,&tz);
        return((tv.tv_sec*1000000.0)+tv.tv_usec);
}

// Function to generate Gaussian noise using Box-Muller transform
float gaussian_box_muller() {
    static boost::mt19937 generator(std::random_device{}());
    static boost::normal_distribution<float> distribution(0.0f, 1.0f);
    return distribution(generator);
}

#include <mpi.h>
#include <iostream>

// Function to calculate the Black-Scholes call option price using Monte Carlo method
float black_scholes_monte_carlo(ui64 S0, ui64 K, float T, float r, float sigma, float q, ui64 num_simulations) {


    float sum_payoffs = 0.0f;
    float payoff;

    for (ui64 i = 0; i < num_simulations; ++i) {
        float Z = gaussian_box_muller();
        float ST = S0 * exp((r - q - 0.5f * sigma * sigma) * T + sigma * sqrt(T) * Z);
        payoff = std::max(ST - K, 0.0f);
        sum_payoffs += payoff;
    }

    return  exp(-r * T) * (sum_payoffs / num_simulations);
}

#include <cmath> // Pour std::erf et std::sqrt

int main(int argc, char* argv[]) {
    MPI_Init(&argc, &argv);

    if (argc != 3) {
        std::cerr << "Usage: " << argv[0] << " <num_simulations> <num_runs>" << std::endl;
        return 1;
    }

    ui64 num_simulations = std::stoull(argv[1]);
    ui64 num_runs        = std::stoull(argv[2]);

    // Input parameters
    ui64 S0      = 100;                   // Initial stock price
    ui64 K       = 110;                   // Strike price
    float T      = 1.0f;                   // Time to maturity (1 year)
    float r      = 0.06f;                  // Risk-free interest rate
    float sigma  = 0.2f;                   // Volatility
    float q      = 0.03f;                  // Dividend yield

    // Generate a random seed at the start of the program using random_device
    std::random_device rd;
    unsigned long long global_seed = rd();  // This will be the global seed

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);  // Rang du processus
    MPI_Comm_size(MPI_COMM_WORLD, &size); // Nombre total de processus

    if(rank == 0) {
        std::cout << "Global initial seed: " << global_seed << "      argv[1]= " << argv[1] << "     argv[2]= " << argv[2] <<  std::endl;
    }

    float sum=0.0f;
    float local_sum=0.0f;
    double t1=dml_micros();


    // Calcul du nombre de simulations par processus
    ui64 local_num_runs = num_runs / size;
    if (rank == size - 1) {
        // Le dernier processus effectue les simulations restantes
        local_num_runs += num_runs % size;
    }

    for (ui64 run = 0; run < local_num_runs; ++run) {

        local_sum += black_scholes_monte_carlo(S0, K, T, r, sigma, q, num_simulations);
    }

    MPI_Reduce(&local_sum, &sum, 1, MPI_FLOAT, MPI_SUM, 0, MPI_COMM_WORLD);

    double t2=dml_micros();

    if (rank == 0) {
        std::cout << std::fixed << std::setprecision(6) << " value= " << sum/num_runs << " in " << (t2-t1)/1000000.0 << " seconds" << std::endl;
    }

    MPI_Finalize();
    return 0;
}
