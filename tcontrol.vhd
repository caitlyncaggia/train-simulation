--
--
-- State machine to control trains
--
--

LIBRARY IEEE;
USE  IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;


ENTITY Tcontrol IS
  PORT(reset, clock, sensor1, sensor2         : IN std_logic;
      sensor3, sensor4, sensor5, sensor6      : IN std_logic;
      switch1, switch2, switch3, switch4      : OUT std_logic;
      dirA, dirB                              : OUT std_logic_vector(1 DOWNTO 0));
END Tcontrol;


ARCHITECTURE a OF Tcontrol IS
  TYPE STATE_TYPE IS (A1B3X, A1B2X, A1B2, A2B3X, A2BS, A4B2X, A4B2, A4XB2X, A4XB2, A1XB3X, A1XB2X, A1XB2);
  SIGNAL state                                						: STATE_TYPE;
  SIGNAL sensor12, sensor24, sensor26, sensor34, sensor36        	: std_logic_vector(1 DOWNTO 0);

BEGIN
  PROCESS (clock, reset)
  BEGIN
        -- Reset to this state
    IF reset = '1' THEN
      state <= A1B3X;
    ELSIF clock'EVENT AND clock = '1' THEN
        -- Case statement to determine next state
      CASE state IS
        WHEN A1B3X =>
          CASE Sensor24 IS
            WHEN "00" => state <= A1B3X;
            WHEN "01" => state <= A2B3X;
            WHEN "10" => state <= A1B2X;
            WHEN "11" => state <= A2BS;
            WHEN OTHERS => state <= A1B3X;
          END CASE;

        WHEN A1B2X =>
          CASE Sensor34 IS
            WHEN "00" => state <= A1B2X;
            WHEN "01" => state <= A4XB2X;
            WHEN "10" => state <= A1B3X;
            WHEN "11" => state <= A2B3X;
            WHEN OTHERS => state <= A1B2X;
          END CASE;

        WHEN A1B2 =>
          CASE Sensor24 IS
            WHEN "00" => state <= A1B2;
            WHEN "01" => state <= A4XB2;
            WHEN "10" => state <= A1B2X;
            WHEN "11" => state <= A4XB2X;
            WHEN OTHERS => state <= A1B2;
          END CASE;
          
         WHEN A2B3X =>
          CASE Sensor12 IS
            WHEN "00" => state <= A2B3X;
            WHEN "01" => state <= A2BS;
            WHEN "10" => state <= A1B3X;
            WHEN "11" => state <= A1B2X;
            WHEN OTHERS => state <= A2B3X;
          END CASE;
        
         WHEN A2BS =>
          CASE Sensor12 IS
            WHEN "00" => state <= A2BS;
            WHEN "01" => state <= A2BS;
            WHEN "10" => state <= A2BS;
            WHEN "11" => state <= A1B2X;
            WHEN OTHERS => state <= A2BS;
          END CASE;
        
        WHEN A4B2X =>
          CASE Sensor34 IS
            WHEN "00" => state <= A4B2X;
            WHEN "01" => state <= A1XB2X;
            WHEN "10" => state <= A4B2;
            WHEN "11" => state <= A2B3X;
            WHEN OTHERS => state <= A4B2X;
          END CASE;
          
        WHEN A4B2 =>
          CASE Sensor24 IS
            WHEN "00" => state <= A4B2;
            WHEN "01" => state <= A1XB2;
            WHEN "10" => state <= A4B2X;
            WHEN "11" => state <= A1XB2X;
            WHEN OTHERS => state <= A4B2;
          END CASE;
        
         WHEN A4XB2X =>
          CASE Sensor36 IS
            WHEN "00" => state <= A4XB2X;
            WHEN "01" => state <= A4B2X;
            WHEN "10" => state <= A4XB2;
            WHEN "11" => state <= A4B2;
            WHEN OTHERS => state <= A4XB2X;
          END CASE;
        
        WHEN A4XB2 =>
          CASE Sensor26 IS
            WHEN "00" => state <= A4XB2;
            WHEN "01" => state <= A4B2;
            WHEN "10" => state <= A4XB2X;
            WHEN "11" => state <= A4B2X;
            WHEN OTHERS => state <= A4XB2;
          END CASE;
          
        WHEN A1XB3X =>
          CASE Sensor26 IS
            WHEN "00" => state <= A1XB3X;
            WHEN "01" => state <= A1B3X;
            WHEN "10" => state <= A1XB2X;
            WHEN "11" => state <= A1B2X;
            WHEN OTHERS => state <= A1XB3X;
          END CASE;
        
         WHEN A1XB2X =>
          CASE Sensor36 IS
            WHEN "00" => state <= A1XB2X;
            WHEN "01" => state <= A1B2X;
            WHEN "10" => state <= A1XB3X;
            WHEN "11" => state <= A1B2;
            WHEN OTHERS => state <= A1XB2X;
          END CASE;
        
        WHEN A1XB2 =>
          CASE Sensor26 IS
            WHEN "00" => state <= A1XB2;
            WHEN "01" => state <= A1B2;
            WHEN "10" => state <= A1XB2X;
            WHEN "11" => state <= A1B2X;
            WHEN OTHERS => state <= A1XB2;
          END CASE;

      END CASE;
    END IF;
  END PROCESS;

      -- combine bits for case statements above
      -- "&" operator combines bits
  sensor12 <= sensor1 & sensor2;
  sensor24 <= sensor2 & sensor4;
  sensor26 <= sensor2 & sensor6;
  sensor34 <= sensor3 & sensor4;
  sensor36 <= sensor3 & sensor6;

  
        -- Outputs that depend on state
  WITH state SELECT
    Switch1 <=  '0' WHEN A2B3X,
          '0' WHEN A2BS,
          '1' WHEN OTHERS;
  WITH state SELECT
    Switch2 <=  '0' WHEN A2B3X,
          '0' WHEN A2BS,
          '1' WHEN OTHERS;
  WITH state SELECT
    Switch3 <=  '1' WHEN A4B2X,
          '1' WHEN A4B2,
          '1' WHEN A4XB2X,
          '1' WHEN A4XB2,
          '0' WHEN OTHERS;
  WITH state SELECT
    Switch4 <=  '1' WHEN A4B2X,
          '1' WHEN A4B2,
          '1' WHEN A4XB2X,
          '1' WHEN A4XB2,
          '0' WHEN OTHERS;
  WITH state SELECT
    DirA  <=  "01" WHEN A4XB2X,
		  "01" WHEN A4XB2,
		  "01" WHEN A1XB3X,
		  "01" WHEN A1XB2X,
		  "01" WHEN A1XB2,
          "10" WHEN OTHERS;
  WITH state SELECT
    DirB  <=  "10" WHEN A1B2,
          "10" WHEN A4B2,
          "10" WHEN A4XB2,
          "10" WHEN A1XB2,
          "00" WHEN A2BS,
          "01" WHEN OTHERS;
END a;


