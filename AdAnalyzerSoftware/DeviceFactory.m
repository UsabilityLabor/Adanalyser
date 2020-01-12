% DeviceFactory class creating _Devices_ objects (see device class in device.m)
%   Parses device definitions
%   Creates a device (containing a device name, a sampling rate and also device specific features 
%   such as electrode positions in case of EEG) for each one being used

% Author: Gernot Heisenberg
%
classdef DeviceFactory

	properties
	end
	
	methods
		% call the parsing methods, if and only if the devices were used and hence the _USED_ flags are set to TRUE
		function eegDevice = createEEGDevice(self, conf)
			if(conf.EEG_DEVICE_USED)
                eegDevice=self.parseEEGDeviceDefinitions(conf.EEG_DEVICE);
            else
                eegDevice=self.parseNothing();
            end
		end
		
		function edaDevice = createEDADevice(self, conf)
			if(conf.EDA_DEVICE_USED)
				edaDevice=self.parseEDADeviceDefinitions(conf.EDA_DEVICE);
			else
                edaDevice=self.parseNothing();
            end
		end

		function hrvDevice = createHRVDevice(self, conf)
			if(conf.HRV_DEVICE_USED)
				hrvDevice=self.parseHRVDeviceDefinitions(conf.HRV_DEVICE);
			else
                hrvDevice=self.parseNothing();
            end
		end
	end
	
	methods(Access=private)
        function DeviceDefs=parseNothing();
            %do Nothing
        end
        % parses Config files and gets the device definitions
		% parse EEG Device File
		function EEGdevice=parseEEGDeviceDefinitions(self,EEGDeviceConfigFile)
			EEGDeviceName="NULL";
            EEGDeviceSamplingRate=0;
            EEGDeviceElectrodePos={};% electrodePositions is a cell containing the strings for each electrode position
            
            fileID = fopen(EEGDeviceConfigFile);
			ConfigFileContents = textscan(fileID,'%s','Delimiter','\n');
			fclose(fileID);
			ConfigFileContents = ConfigFileContents{1};
			[numEEGDeviceDefs,~] = size(ConfigFileContents);
			for i = 1:numEEGDeviceDefs
				eegDeviceDef = ConfigFileContents{i};
				values = textscan(eegDeviceDef,'%s','Delimiter','=');
                values = values{1}; %this is essential for accessing the cells correctly as values pairs
                if values(1) == "EEG_DEVICE_NAME"
                    EEGDeviceName = values(2);
                elseif values(1)== "EEG_SAMPLING_FREQUENCY"
                    EEGDeviceSamplingRate = values(2);
                elseif values(1) == "EEG_ELECTRODES_POSITIONS"
                    %split the Electrode positions by the comma delimiter
                    %and make it a cell
                    EEGDeviceElectrodePos = split(values(2),",");
                else
                    %do nothing
                end
            end
            %create a device Object and make it a special EEG device
            device=Device();
            EEGdevice=device.createEEGDevice(EEGDeviceName,EEGDeviceSamplingRate,EEGDeviceElectrodePos);
        end
        
		% parse EDA Device File
		function EDAdevice=parseEDADeviceDefinitions(self,EDADeviceConfigFile)
			fileID = fopen(EDADeviceConfigFile);
			ConfigFileContents = textscan(fileID,'%s','Delimiter','\n');
			fclose(fileID);
			ConfigFileContents = ConfigFileContents{1};
            [numEDADeviceDefs,~] = size(ConfigFileContents);
			for i = 1:numEDADeviceDefs
				edaDeviceDef = ConfigFileContents{i};
				values = textscan(edaDeviceDef,'%s','Delimiter','=');
                values = values{1}; %this is essential for accessing the cells correctly as values pairs
                if values(1) == "EDA_DEVICE_NAME"
                    EDADeviceName = values(2);
                elseif values(1)== "EDA_SAMPLING_FREQUENCY"
                    EDADeviceSamplingRate = values(2);
                else
                    %do nothing
                end
            end
            %create a device Object and make it a special EDA standard device
            device=Device();
            EDAdevice=device.createStandardDevice(EDADeviceName,EDADeviceSamplingRate);
        end
        
        % parse HRV Device File
		function HRVdevice=parseHRVDeviceDefinitions(self,HRVDeviceConfigFile)
			fileID = fopen(HRVDeviceConfigFile);
			ConfigFileContents = textscan(fileID,'%s','Delimiter','\n');
			fclose(fileID);
			ConfigFileContents = ConfigFileContents{1};
            [numHRVDeviceDefs,~] = size(ConfigFileContents);
			for i = 1:numHRVDeviceDefs
				hrvDeviceDef = ConfigFileContents{i};
				values = textscan(hrvDeviceDef,'%s','Delimiter','=');
                values = values{1}; %this is essential for accessing the cells correctly as values pairs
                if values(1) == "HRV_DEVICE_NAME"
                    HRVDeviceName = values(2);
                elseif values(1)== "HRV_SAMPLING_FREQUENCY"
                    HRVDeviceSamplingRate = values(2);
                else
                    %do nothing
                end
            end
            %create a device Object and make it a special HRV standard device
            device=Device();
            HRVdevice=device.createStandardDevice(HRVDeviceName,HRVDeviceSamplingRate);
		end
	end
end