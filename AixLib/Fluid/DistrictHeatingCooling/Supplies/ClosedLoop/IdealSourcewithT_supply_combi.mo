within AixLib.Fluid.DistrictHeatingCooling.Supplies.ClosedLoop;
model IdealSourcewithT_supply_combi

      replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model for water"
      annotation (choicesAllMatching = true);

       parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
      "Nominal pressure drop";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    "Fluid connector for connecting the ideal plant to the cold line of the network"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    "Fluid connector for connecting the ideal plant to the warm line of the network"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  AixLib.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Medium, m_flow_nominal=2,
    tau=0,
    allowFlowReversal=false,
    T_start=283.15)
    annotation (Placement(transformation(extent={{38,10},{58,-10}})));
  Modelica.Blocks.Interfaces.RealInput  TIn(unit="K")
 "Prescribed supply temperature"
    annotation (Placement(transformation(extent={{-126,60},{-86,100}})));

  Sensors.MassFlowRate m_flow(redeclare package Medium = Medium,
      allowFlowReversal=false)
    annotation (Placement(transformation(extent={{68,10},{88,-10}})));
  Sensors.TemperatureTwoPort senTem1( redeclare package Medium = Medium,m_flow_nominal=2, tau=0,
    allowFlowReversal=false)
    annotation (Placement(transformation(extent={{-88,10},{-68,-10}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    nPorts=2,
    m_flow_nominal=2,
    V=5) annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Utilities.Sensors.EnergyMeter energyMeter
    annotation (Placement(transformation(extent={{90,16},{102,32}})));
  HeatExchangers.PrescribedOutlet preOut(
    redeclare package Medium = Medium,
    m_flow_nominal=3,
    use_X_wSet=false,
    dp_nominal=0)
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Sources.FixedBoundary bou( redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{-92,28},{-72,48}})));
  Modelica.Blocks.Interfaces.RealInput dpIn
    annotation (Placement(transformation(extent={{-124,34},{-84,74}})));
  Utilities.Sensors.FuelCounter fuelCounter
    annotation (Placement(transformation(extent={{84,-34},{104,-14}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMin=273.15 + 5, uMax=273.15 + 7)
    annotation (Placement(transformation(extent={{-72,-44},{-52,-24}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=max(0, 100000*(-1*(
        limiter.y - 273.15) + 7)))
    annotation (Placement(transformation(extent={{36,-42},{16,-22}})));
  Movers.FlowControlled_dp fan(
   redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=11,
    inputType=AixLib.Fluid.Types.InputType.Continuous,
    addPowerToMedium=false,
    use_inputFilter=true,
    y_start=1,
    dp_start=50000)
    annotation (Placement(transformation(extent={{-28,10},{-8,-10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(uMax=273.15 + 15, uMin=273.15 + 13)
    annotation (Placement(transformation(extent={{-72,-80},{-52,-60}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=max(0, 100000*(1.5*(
        limiter1.y - 273.15) - 12)))
    annotation (Placement(transformation(extent={{38,-78},{18,-58}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{6,-56},{-14,-36}})));
  Modelica.Blocks.Sources.BooleanTable booleanTable(
  startValue=false, table={0,
        1.2e+07,2.205e+07})
    annotation (Placement(transformation(extent={{62,-56},{42,-36}})));
equation
  connect(m_flow.port_b, port_b)
    annotation (Line(points={{88,0},{100,0}}, color={0,127,255}));
  connect(senTem1.port_b, vol.ports[1]) annotation (Line(points={{-68,0},{-52,0}},
                            color={0,127,255}));
  connect(preOut.port_b, senTem.port_a)
    annotation (Line(points={{30,0},{38,0}}, color={0,127,255}));
  connect(TIn, preOut.TSet)
    annotation (Line(points={{-106,80},{8,80},{8,8}},     color={0,0,127}));
  connect(preOut.Q_flow, energyMeter.p) annotation (Line(points={{31,8},{32,8},{
          32,24},{90.4,24}},               color={0,0,127}));
  connect(port_a, senTem1.port_a)
    annotation (Line(points={{-100,0},{-88,0}}, color={0,127,255}));
  connect(senTem.port_b, m_flow.port_a)
    annotation (Line(points={{58,0},{68,0}}, color={0,127,255}));
  connect(bou.ports[1], senTem1.port_b) annotation (Line(points={{-72,38},{-66,38},
          {-66,0},{-68,0}},     color={0,127,255}));
  connect(senTem1.T, limiter.u) annotation (Line(points={{-78,-11},{-78,-34},{-74,
          -34}},           color={0,0,127}));
  connect(vol.ports[2], fan.port_a)
    annotation (Line(points={{-48,0},{-28,0}}, color={0,127,255}));
  connect(fan.port_b, preOut.port_a)
    annotation (Line(points={{-8,0},{10,0}}, color={0,127,255}));
  connect(fan.P, fuelCounter.fuel_in) annotation (Line(points={{-7,-9},{38.5,-9},
          {38.5,-24},{84,-24}}, color={0,0,127}));
  connect(senTem1.T, limiter1.u)
    annotation (Line(points={{-78,-11},{-78,-70},{-74,-70}}, color={0,0,127}));
  connect(switch1.y, fan.dp_in) annotation (Line(points={{-15,-46},{-16,-46},{-16,
          -12},{-18,-12}}, color={0,0,127}));
  connect(realExpression.y, switch1.u1) annotation (Line(points={{15,-32},{12,-32},
          {12,-38},{8,-38}}, color={0,0,127}));
  connect(realExpression1.y, switch1.u3) annotation (Line(points={{17,-68},{14,-68},
          {14,-54},{8,-54}}, color={0,0,127}));
  connect(booleanTable.y, switch1.u2)
    annotation (Line(points={{41,-46},{8,-46}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{100,100}}),                                  graphics={
        Rectangle(
          extent={{-80,80},{80,0}},
          lineColor={28,108,200},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-80},{80,0}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.None)}),                       Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    Documentation(revisions="<html>
<ul>
<li><i>August 09, 2018</i> ,by Tobias Blacha:<br/>
Implemented </li>
</ul>
</html>"));
end IdealSourcewithT_supply_combi;