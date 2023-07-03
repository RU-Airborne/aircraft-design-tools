import pandas as pd
import os.path
# import numpy as np
import aerosandbox.numpy as np
import matplotlib.pyplot as plt
import matplotlib as mpl
from aerosandbox.modeling import InterpolatedModel, UnstructuredInterpolatedModel
# import seaborn
from tqdm import tqdm
from typing import Union
import re

class PropData:
    def __init__(self, prop_name: str, folder: Union[str, os.PathLike] = "./PROP_DATA/PERFILES_WEB/PERFILES2") -> None:
        self.folder = folder
        if ("PER3_" and ".dat") in prop_name:
            self.prop_name = prop_name.split(".")[0].split("_")[1]
        else:
            self.prop_name = prop_name
        self.file_name = "PER3_" + self.prop_name + ".dat"
        self.fullpath = os.path.join(self.folder, self.file_name)
        return
    
    def read_prop_data(self) -> None:
        with open(self.fullpath, "r") as f:
            lines = f.readlines()
            rpm = []
            data = [[]]
            rpm_count = 0
            read_pitch = True
            for line in lines:
                if (".dat" in line) and (read_pitch == True):
                    self.prop_geometry_name = line.strip().split("(")[0].strip()
                    self.prop_diam = float(self.prop_geometry_name.split("x")[0])
                    self.prop_pitch = float(re.findall(r"[-+]?(?:\d*\.*\d+)", self.prop_geometry_name.split("x")[1])[0])
                    read_pitch = False
                    continue
                if "PROP" in line:
                    rpm.append(line.lstrip("         PROP RPM =       ").strip())

            rpm = np.array(rpm).astype(np.float64)
            data_line = []
            for i, line in enumerate(lines):
                try:
                    tmp = float(line.strip().split()[0])
                    data_line.append(i)
                except:
                    continue
            data_line = np.array(data_line)
            data_line = np.reshape(data_line, (rpm.size, -1))

            V_mph = np.zeros(data_line.shape)
            J = np.zeros(data_line.shape)
            Pe = np.zeros(data_line.shape)
            Ct = np.zeros(data_line.shape)
            Cp = np.zeros(data_line.shape)
            pwr_HP = np.zeros(data_line.shape)
            torque_INLBF = np.zeros(data_line.shape)
            thrust_LBF = np.zeros(data_line.shape)
            pwr_W = np.zeros(data_line.shape)
            torque_NM = np.zeros(data_line.shape)
            thrust_N = np.zeros(data_line.shape)
            thrust_per_power_gW = np.zeros(data_line.shape)
            mach = np.zeros(data_line.shape)
            reynolds = np.zeros(data_line.shape)
            figure_of_merit = np.zeros(data_line.shape)

            # [rpm, vel]
            (num_rpm, num_vel) = data_line.shape
            for i in range(num_rpm):
                for j in range(num_vel):
                    tmp_data = lines[data_line[i, j]].strip()
                    tmp_data = np.array(tmp_data.split()).astype(np.float64)
                    if tmp_data.size != 15:
                        extra = np.empty(shape = (15 - tmp_data.size,))
                        extra[:] = np.nan
                        tmp_data = np.concatenate([tmp_data, extra], axis=0)
                    [V_mph[i,j],J[i,j],Pe[i,j],Ct[i,j],Cp[i,j],pwr_HP[i,j],
                        torque_INLBF[i,j],thrust_LBF[i,j],pwr_W[i,j],torque_NM[i,j],
                        thrust_N[i,j],thrust_per_power_gW[i,j],mach[i,j],reynolds[i,j],figure_of_merit[i,j]] = tmp_data
        self.rpm = rpm
        self.num_rpm = num_rpm
        self.num_vel = num_vel
        self.V_mph = V_mph
        self.V_fps = self.V_mph * 1.466667
        self.J = J
        self.Pe = Pe
        self.Ct = Ct
        self.Cp = Cp
        self.pwr_HP = pwr_HP
        self.torque_INLBF = torque_INLBF
        self.thrust_LBF = thrust_LBF
        self.pwr_W = pwr_W
        self.torque_NM = torque_NM
        self.thrust_N = thrust_N
        self.thrust_per_power_gW = thrust_per_power_gW
        self.mach = mach
        self.reynolds = reynolds
        self.figure_of_merit = figure_of_merit
        self.J_avg = np.mean(self.J, 0)
        self.model_input = {"rpm": self.rpm, "J": self.J_avg}
        self.efficiency_model = InterpolatedModel(x_data_coordinates= self.model_input,
                                            y_data_structured=self.Pe,)
        self.thrust_LBF_model = InterpolatedModel(x_data_coordinates= self.model_input,
                                            y_data_structured=self.thrust_LBF,)
        self.power_W_model = InterpolatedModel(x_data_coordinates= self.model_input,
                                            y_data_structured=self.pwr_W,)
        self.tip_mach_model = InterpolatedModel(x_data_coordinates= self.model_input,
                                            y_data_structured=self.mach,)
    
    def get_value_at_given_J(self, J_input: float = 0, max_mach: float = 0.8) -> dict:
        max_mach_condition = self.mach[:,J_input] < max_mach
        rpm_filtered = self.rpm[max_mach_condition]
        Pe_filtered = self.Pe[max_mach_condition, J_input]
        Ct_filtered = self.Ct[max_mach_condition, J_input]
        Cp_filtered = self.Cp[max_mach_condition, J_input]
        pwr_HP_filtered = self.pwr_HP[max_mach_condition, J_input]
        torque_INLBF_filtered = self.torque_INLBF[max_mach_condition, J_input]
        thrust_LBF_filtered = self.thrust_LBF[max_mach_condition, J_input]
        pwr_W_filtered = self.pwr_W[max_mach_condition, J_input]
        torque_NM_filtered = self.torque_NM[max_mach_condition, J_input]
        thrust_N_filtered = self.thrust_N[max_mach_condition, J_input]
        thrust_per_power_gW_filtered = self.thrust_per_power_gW[max_mach_condition, J_input]
        
        max_rpm_filtered = np.max(rpm_filtered)
        max_Pe_filtered = np.max(Pe_filtered)
        max_Ct_filtered = np.max(Ct_filtered)
        max_Cp_filtered = np.max(Cp_filtered)
        max_pwr_HP_filtered = np.max(pwr_HP_filtered)
        max_torque_INLBF_filtered = np.max(torque_INLBF_filtered)
        max_thrust_LBF_filtered = np.max(thrust_LBF_filtered)
        max_pwr_W_filtered = np.max(pwr_W_filtered)
        max_torque_NM_filtered = np.max(torque_NM_filtered)
        max_thrust_N_filtered = np.max(thrust_N_filtered)
        max_thrust_per_power_gW_filtered = np.max(thrust_per_power_gW_filtered)

        data = {
            "rpm_filtered": rpm_filtered,
            "Pe_filtered": Pe_filtered,
            "Ct_filtered": Ct_filtered,
            "Cp_filtered": Cp_filtered,
            "pwr_HP_filtered": pwr_HP_filtered,
            "torque_INLBF_filtered": torque_INLBF_filtered,
            "thrust_LBF_filtered": thrust_LBF_filtered,
            "pwr_W_filtered": pwr_W_filtered,
            "torque_NM_filtered": torque_NM_filtered,
            "thrust_N_filtered": thrust_N_filtered,
            "thrust_per_power_gW_filtered": thrust_per_power_gW_filtered,
            "max_rpm_filtered": max_rpm_filtered,
            "max_Pe_filtered": max_Pe_filtered,
            "max_Ct_filtered": max_Ct_filtered,
            "max_Cp_filtered": max_Cp_filtered,
            "max_pwr_HP_filtered": max_pwr_HP_filtered,
            "max_torque_INLBF_filtered": max_torque_INLBF_filtered,
            "max_thrust_LBF_filtered": max_thrust_LBF_filtered,
            "max_pwr_W_filtered": max_pwr_W_filtered,
            "max_torque_NM_filtered": max_torque_NM_filtered,
            "max_thrust_N_filtered": max_thrust_N_filtered,
            "max_thrust_per_power_gW_filtered": max_thrust_per_power_gW_filtered,
        }

        return data
    # generate report
        # identify infeasible thrusts by tip mach
        # motor power based on prop power needed