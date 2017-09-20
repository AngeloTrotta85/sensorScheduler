//============================================================================
// Name        : SensorsScheduler.cpp
// Author      : Angelo Trotta
// Version     :
// Copyright   : Your copyright notice
// Description : Hello World in C++, Ansi-style
//============================================================================

#include <stdlib.h>
#include <stdio.h>
#include <iostream>     // std::cout
#include <fstream>      // std::ifstream
#include <algorithm>    // std::find
#include <vector>       // std::vector
#include <list>       // std::list
#include <cstdlib>
#include <ctime>

using namespace std;


class InputParser{
public:
	InputParser (int &argc, char **argv){
		for (int i=1; i < argc; ++i)
			this->tokens.push_back(std::string(argv[i]));
	}
	const std::string& getCmdOption(const std::string &option) const{
		std::vector<std::string>::const_iterator itr;
		itr =  std::find(this->tokens.begin(), this->tokens.end(), option);
		if (itr != this->tokens.end() && ++itr != this->tokens.end()){
			return *itr;
		}
		static const std::string empty_string("");
		return empty_string;
	}
	bool cmdOptionExists(const std::string &option) const{
		return std::find(this->tokens.begin(), this->tokens.end(), option)
		!= this->tokens.end();
	}
private:
	std::vector <std::string> tokens;
};

void printVec(bool p, int t, std::vector<int> &vec) {
	if (p) {
		cout << t << " Sensors battery: ";
		for (auto &v : vec) {
			cout << v << " ";
		}
		cout << endl;
	}
}

int main(int argc, char **argv) {
	int lam = 1;
	int s = 1;
	int k;
	int n4clusterPlus;
	int einit = 100;
	int eboot = 1;
	int eon = 1;
	int estb = 1;
	int lifetime = 0;
	bool simulative = false;
	bool debugPrint = false;
	bool clustering = true;
	bool onlyLP = false;
	bool onlySW = false;

	//cout << "Begin!!!" << endl;

	InputParser input(argc, argv);

	const std::string &lambdaInput = input.getCmdOption("-l");
	const std::string &sensorsNumber = input.getCmdOption("-s");
	const std::string &energyInit = input.getCmdOption("-ei");
	const std::string &energyBoot = input.getCmdOption("-eb");
	const std::string &energyOn = input.getCmdOption("-eo");
	const std::string &energyStb = input.getCmdOption("-es");
	const std::string &isSimulative = input.getCmdOption("-sim");
	const std::string &debugP = input.getCmdOption("-d");
	const std::string &makeClusts = input.getCmdOption("-clust");
	const std::string &onlySWstr = input.getCmdOption("-sw");
	const std::string &onlyLPstr = input.getCmdOption("-lp");

	if (!onlySWstr.empty()) {
		int tmp = atoi(onlySWstr.c_str());
		onlySW = tmp != 0;
	}

	if (!onlyLPstr.empty()) {
		int tmp = atoi(onlyLPstr.c_str());
		onlyLP = tmp != 0;
	}

	if (onlyLP && onlySW) {
		cerr << "Error: onlyLP and onlySW are both true. Set at most one of them." << endl;
		return EXIT_FAILURE;
	}

	if (!makeClusts.empty()) {
		int tmp = atoi(makeClusts.c_str());
		clustering = tmp != 0;
	}

	if (!isSimulative.empty()) {
		int tmp = atoi(isSimulative.c_str());
		simulative = tmp != 0;
	}

	if (!debugP.empty()) {
		int tmp = atoi(debugP.c_str());
		debugPrint = tmp != 0;
	}

	if (!lambdaInput.empty()) {
		lam = atoi(lambdaInput.c_str());
	}

	if (!sensorsNumber.empty()) {
		s = atoi(sensorsNumber.c_str());
	}

	if (!energyInit.empty()) {
		einit = atoi(energyInit.c_str());
	}
	if (!energyBoot.empty()) {
		eboot = atoi(energyBoot.c_str());
	}
	if (!energyOn.empty()) {
		eon = atoi(energyOn.c_str());
	}
	if (!energyStb.empty()) {
		estb = atoi(energyStb.c_str());
	}

	if (s < lam) {
		cerr << "The sensors number is less then the lambda value" << endl;
		return EXIT_FAILURE;
	}


	if (clustering) {
		k = s / lam;
		n4clusterPlus = (s % lam) + lam;
	}
	else {
		k = 1;
		n4clusterPlus = s;
	}

	if (simulative) {
		std::vector<int> vecSensors(s, einit);

		printVec(debugPrint, lifetime, vecSensors);

		for (int i = 0; i < k; ++i) {
			int idxB, idxE;
			idxB = i * lam;
			if ((i == k-1) && (n4clusterPlus != lam)) {
				//int st = (einit - eboot) / (lam * (estb + eon));
				int st = (einit - eboot) / (lam * (estb + eon));
				int newIB, newIE, lastIB;

				idxE = idxB + n4clusterPlus;

				newIB = idxB;
				lastIB = newIB;
				newIE = newIB + lam - 1;

				/*for (int j = idxB; j < (idxB+lam); ++j) {
					vecSensors[j] -= eboot;
				}*/

				while (newIB < s) {

					for (int j = 0; j < st; ++j) {
						bool okRound = true;

						for (int jj = newIB; jj < (newIB+lam); ++jj) {
							int idxx = ((jj-idxB) % n4clusterPlus) + idxB;
							if (vecSensors[idxx] < (estb + eon)) {
								okRound = false;
								break;
							}
						}

						if (okRound) {
							for (int jj = newIB; jj < (newIB+lam); ++jj) {
								//for (int jj = newIB; jj <= newIE; ++jj) {
								int idxx = ((jj-idxB) % n4clusterPlus) + idxB;
								vecSensors[idxx] -= estb + eon;
							}
							lastIB = newIB;
							++lifetime;
							printVec(debugPrint, lifetime, vecSensors);
						}
					}

					++newIB;
					++newIE;
					if (newIE >= s) {
						newIE = ((newIE-idxB) % n4clusterPlus) + idxB;
					}
					if (newIB < s) {
						vecSensors[newIE] -= eboot;
					}
				}

				bool okNewRound = true;
				int newRoundNTry = n4clusterPlus / lam;
				do {
					for (int jj = lastIB; jj < (lastIB+lam); ++jj) {
						int idxx = ((jj-idxB) % n4clusterPlus) + idxB;
						if (vecSensors[idxx] < (estb + eon)) {
							okNewRound = false;
							break;
						}
					}

					if (okNewRound) {
						for (int jj = lastIB; jj < (lastIB+lam); ++jj) {
							//for (int jj = newIB; jj <= newIE; ++jj) {
							int idxx = ((jj-idxB) % n4clusterPlus) + idxB;
							vecSensors[idxx] -= estb + eon;
						}
						++lifetime;
						printVec(debugPrint, lifetime, vecSensors);
					}
					else {
						lastIB = ((lastIB + lam - idxB) % n4clusterPlus) + idxB;
						if (newRoundNTry > 0) {
							okNewRound = true;
							--newRoundNTry;
						}
					}
				} while (okNewRound);
			}
			else {
				idxE = idxB + lam;

				for (int j = idxB; j < idxE; ++j) {
					vecSensors[j] -= eboot;
				}

				while (vecSensors[idxB] >= (eon + estb)) {
					for (int j = idxB; j < idxE; ++j) {
						vecSensors[j] -= eon + estb;
					}
					++lifetime;
					printVec(debugPrint, lifetime, vecSensors);
				}
			}
		}
	}
	else {
		int lt_full = (einit - eboot) / (eon + estb);
		if (debugPrint) {
			cout << "Lifetime of each lambda-cluster: " << lt_full << endl;
		}

		if (n4clusterPlus == lam) {
			lifetime = k * lt_full;
		}
		else {
			//int st = (einit - eboot - eon) / (lam * estb);
			int st = (einit - eboot) / (lam * (estb + eon));

			lifetime = (k - 1) * lt_full;

			lifetime += st * n4clusterPlus;

			if (debugPrint) {
				cout << "ST value: " << st << " - Sensors on last cluster: " << n4clusterPlus << endl;
			}

			if (st > 0) {
				int residualEn = einit - eboot - (st * lam * (estb + eon));
				if (debugPrint) {
					cout << "ST: " << st << " - Remaining Energy: " << residualEn << endl;
				}

				if (residualEn < 0) {
					lifetime = lifetime - 1;
				}
				else if (residualEn >= (estb + eon)) {
					lifetime += residualEn / (estb + eon);
				}
			}
			else {
				int residualEn = einit - eboot;
				if (debugPrint) {
					cout << "ST: " << st << " - Remaining Energy: " << residualEn << endl;
				}

				if (residualEn > (estb + eon)) {
					lifetime += residualEn / (estb + eon);
				}
			}
		}
	}

	//cout << "Sensors: " << s << "; lambda: " << lam << "; k: " << k << "; n4cPlus: " << n4clusterPlus << endl;


	//cout << "FinalLifetime " << lifetime << endl;

	cout << lifetime;

	//cout << "end!!!" << endl; // prints !!!Hello World!!!
	return EXIT_SUCCESS;
}
