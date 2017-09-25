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

void printVec(bool p, int t, std::vector<unsigned long int> &vec) {
	if (p) {
		cout << t << " Sensors battery: ";
		for (auto &v : vec) {
			cout << v << " ";
		}
		cout << endl;
	}
}

void printVec2(bool p, int t, std::vector<std::pair<unsigned long int, bool> > &vec) {
	if (p) {
		cout << t << " Sensors battery: ";
		for (auto &v : vec) {
			cout << v.first << "|" << v.second << " ";
		}
		cout << endl;
	}
}

int main(int argc, char **argv) {
	int lam = 1;
	int s = 1;
	int k;
	int n4clusterPlus;
	unsigned long int einit = 100;
	unsigned long int eboot = 1;
	unsigned long int eon = 1;
	unsigned long int estb = 1;
	int lifetime = 0;
	bool simulative = false;
	bool debugPrint = false;
	bool clustering = true;
	bool onlyLP = false;
	unsigned long int estbLP;
	bool onlySW = false;
	bool randomSim = false;
	double selfDischarge = 1;
	double tslot = 1;
	long double selfDischargePerSlot = 1;

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
	const std::string &random_str = input.getCmdOption("-rand");
	const std::string &selfDischarge_str = input.getCmdOption("-sd");
	const std::string &timeSlot_str = input.getCmdOption("-ts");

	if (!random_str.empty()) {
		int tmp = atoi(random_str.c_str());
		randomSim = tmp != 0;
	}

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

	if (!timeSlot_str.empty()) {
		tslot = atof(timeSlot_str.c_str());
	}

	if (!selfDischarge_str.empty()) {
		selfDischarge = atof(selfDischarge_str.c_str());
	}

	if (!lambdaInput.empty()) {
		lam = atoi(lambdaInput.c_str());
	}

	if (!sensorsNumber.empty()) {
		s = atoi(sensorsNumber.c_str());
	}

	if (!energyInit.empty()) {
		einit = atoi(energyInit.c_str());
		einit = einit * 1000000; // converting J in uJ
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

	if (selfDischarge > 0) {
		// selfDischarge is per months
		long double selfDischargeRatio = selfDischarge / 100.0;
		long double slotsPerMonth = (30.0 * 24.0 * 60.0 * 60.0) / tslot;

		selfDischargePerSlot = powl(selfDischargeRatio, 1.0 / slotsPerMonth);

		//cout << "selfDischargeRatio: " << selfDischargeRatio << " -  slotsPerMonth: " << slotsPerMonth << endl;
		//fprintf (stdout, "Self-discharge per slot: %Lf\n", selfDischargePerSlot);
		//cout << "Self-discharge per slot: " << selfDischargePerSlot << endl;
		//exit(0);
	}
	else {
		selfDischargePerSlot = 1.0;
	}

	estbLP = estb;
	if (onlySW) {
		estb = eboot;
		eboot = 0;
	}
	else if (onlyLP) {
		estb = 0;
		eboot = 0;
	}

	if (clustering) {
		k = s / lam;
		n4clusterPlus = (s % lam) + lam;
	}
	else {
		k = 1;
		n4clusterPlus = s;
	}

	if (randomSim) {
		std::vector<std::pair<unsigned long int, bool> > vecSensors(s, make_pair(einit, false));
		/*for (auto it = vecSensors.begin(); it != vecSensors.end(); it++) {
			it->first = einit;
			it->second = false;
		}*/

		//cout << "Making random" << endl;

		printVec2(debugPrint, lifetime, vecSensors);

		while ((int)vecSensors.size() >= lam) {
			std::vector<int> lamIdx(lam, -1);
			int nextIdx = 0;

			do {
				int r = rand() % vecSensors.size();

				bool idxOk = true;
				for (int i = 0; i < nextIdx; ++i) {
					if (lamIdx[i] == r) {
						idxOk = false;
						break;
					}
				}

				if (idxOk) {
					lamIdx[nextIdx] = r;
					nextIdx++;
				}
			} while(nextIdx < ((int)lamIdx.size()));

			if (debugPrint) {
				cout << "Random indexes over " << vecSensors.size() << " elements: ";
				for (auto& ii : lamIdx) {
					cout << ii << " ";
				}
				cout << endl;
			}

			for (auto& ii : lamIdx) {
				if (vecSensors[ii].second) {
					if (vecSensors[ii].first <= eon) {
						vecSensors[ii].first = 0;
					}
					else {
						vecSensors[ii].first -= eon;
					}
				}
				else {
					if (vecSensors[ii].first <= (eon + eboot)) {
						vecSensors[ii].first = 0;
					}
					else {
						vecSensors[ii].first -= eon + eboot;
					}
				}

				if ((rand() % 2) == 0) {
					vecSensors[ii].second = true;
				}
				else {
					vecSensors[ii].second = false;
				}
			}

			for (auto it = vecSensors.begin(); it != vecSensors.end(); it++) {
				if (it->second) {
					if (it->first <= estb) {
						it->first = 0;
					}
					else {
						it->first = it->first - estb;
					}
				}
			}



			++lifetime;
			printVec2(debugPrint, lifetime, vecSensors);


			/*if ((rand() % 1000) < 2) {
				printVec2(true, lifetime, vecSensors);
			}*/

			bool removed;
			do {
				removed = false;
				for (auto it = vecSensors.begin(); it != vecSensors.end(); it++) {
					if (	((it->second) && (it->first < eon)) ||
							((!it->second) && (it->first < (eon + eboot))) ){
						vecSensors.erase(it);
						removed = true;
						break;
					}
				}
			} while (removed);
		}
	}
	else {

		if (simulative) {
			std::vector<unsigned long int> vecSensors(s, einit);

			printVec(debugPrint, lifetime, vecSensors);

			for (int i = 0; i < k; ++i) {
				int idxB, idxE;
				idxB = i * lam;
				if ((i == k-1) && (n4clusterPlus != lam)) {
					//int st = (einit - eboot) / (lam * (estb + eon));
					int st = (einit - eboot) / (lam * (estb + eon));
					if (onlyLP) {
						//st = (einit - eboot) / (lam * (estbLP + eon));
						st = vecSensors[idxB] / (lam * (estbLP + eon));
						if (debugPrint) {
							cout << "ST: " << st << endl;
						}
					}
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
									if (vecSensors[idxx] <= (estb + eon)) {
										vecSensors[idxx] = 0;
									}
									else {
										vecSensors[idxx] -= estb + eon;
									}
								}
								lastIB = newIB;
								if (onlyLP) {
									for (auto& v : vecSensors) {
										if (v <= estbLP) {
											v = 0;
										}
										else {
											v -= estbLP;
										}
									}
								}

								// remove the self-discharging
								for (unsigned int j = 0; j < vecSensors.size(); ++j) {
									vecSensors[j] = (long double)(((long double) vecSensors[j]) * selfDischargePerSlot);
								}

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
								if (vecSensors[idxx] <= (estb + eon)) {
									vecSensors[idxx] = 0;
								}
								else {
									vecSensors[idxx] -= estb + eon;
								}
							}
							if (onlyLP) {
								for (auto& v : vecSensors) {
									if (v <= estbLP) {
										v = 0;
									}
									else {
										v -= estbLP;
									}
								}
							}

							// remove the self-discharging
							for (unsigned int j = 0; j < vecSensors.size(); ++j) {
								vecSensors[j] = (long double)(((long double) vecSensors[j]) * selfDischargePerSlot);
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
						if (vecSensors[j] <= eboot) {
							vecSensors[j] = 0;
						}
						else {
							vecSensors[j] -= eboot;
						}
					}

					if (onlyLP) {
						while (vecSensors[idxB] >= (eon + estbLP)) {
							for (int j = idxB; j < idxE; ++j) {
								if (vecSensors[j] <= eon) {
									vecSensors[j] = 0;
								}
								else {
									vecSensors[j] -= eon;
								}
							}
							for (auto& v : vecSensors) {
								if (v <= estbLP) {
									v = 0;
								}
								else {
									v -= estbLP;
								}
							}

							// remove the self-discharging
							for (unsigned int j = 0; j < vecSensors.size(); ++j) {
								vecSensors[j] = (long double)(((long double) vecSensors[j]) * selfDischargePerSlot);
							}

							++lifetime;
							printVec(debugPrint, lifetime, vecSensors);
						}
					}
					else {
						while (vecSensors[idxB] >= (eon + estb)) {
							for (int j = idxB; j < idxE; ++j) {
								if (vecSensors[j] <= (eon + estb)) {
									vecSensors[j] = 0;
								}
								else {
									vecSensors[j] -= eon + estb;
								}
							}

							// remove the self-discharging
							for (unsigned int j = 0; j < vecSensors.size(); ++j) {
								vecSensors[j] = (long double)(((long double) vecSensors[j]) * selfDischargePerSlot);
							}

							++lifetime;
							printVec(debugPrint, lifetime, vecSensors);
						}
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
					unsigned long int residualEn = einit - eboot - (st * lam * (estb + eon));
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
					unsigned long int residualEn = einit - eboot;
					if (debugPrint) {
						cout << "ST: " << st << " - Remaining Energy: " << residualEn << endl;
					}

					if (residualEn > (estb + eon)) {
						lifetime += residualEn / (estb + eon);
					}
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
