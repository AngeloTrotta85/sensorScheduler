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

	//cout << "Begin!!!" << endl;

	InputParser input(argc, argv);

	const std::string &lambdaInput = input.getCmdOption("-l");
	const std::string &sensorsNumber = input.getCmdOption("-s");
	const std::string &energyInit = input.getCmdOption("-ei");
	const std::string &energyBoot = input.getCmdOption("-eb");
	const std::string &energyOn = input.getCmdOption("-eo");
	const std::string &energyStb = input.getCmdOption("-es");

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

	k = s / lam;
	n4clusterPlus = (s % lam) + lam;

	int lt_full = (einit - eboot) / (eon + estb);

	if (n4clusterPlus == lam) {
		lifetime = k * lt_full;
	}
	else {
		double st;

		lifetime = (k - 1) * lt_full;

		//st = (einit - eboot - eon) / (lam * estb);
		st = (einit - eboot) / (lam * (estb + eon));

		lifetime += st * n4clusterPlus;

		if (st > 0) {
			int residualEn = einit - (2 * eboot) - (st * lam * (estb + eon));
			//cout << "ST: " << st << " - Remaining Energy: " << residualEn << endl;

			if (residualEn < 0) {
				lifetime = lifetime - 1;
			}
			else if (residualEn > (estb + eon)) {
				lifetime += residualEn / (estb + eon);
			}
		}
		else {
			int residualEn = einit - eboot;
			//cout << "ST: " << st << " - Remaining Energy: " << residualEn << endl;

			if (residualEn > (estb + eon)) {
				lifetime += residualEn / (estb + eon);
			}
		}
	}

	//cout << "Sensors: " << s << "; lambda: " << lam << "; k: " << k << "; n4cPlus: " << n4clusterPlus << endl;


	//cout << "FinalLifetime " << lifetime << endl;

	cout << lifetime;

	//cout << "end!!!" << endl; // prints !!!Hello World!!!
	return EXIT_SUCCESS;
}
