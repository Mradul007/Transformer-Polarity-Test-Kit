classdef Single_Phase_Transformer_Polarity_test_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        TextArea_4                     matlab.ui.control.TextArea
        TextArea_3                     matlab.ui.control.TextArea
        TextArea_2                     matlab.ui.control.TextArea
        TextArea                       matlab.ui.control.TextArea
        SupplyVoltageEditField         matlab.ui.control.NumericEditField
        SupplyVoltageEditFieldLabel    matlab.ui.control.Label
        SecondaryTurnsEditField        matlab.ui.control.NumericEditField
        SecondaryTurnsEditFieldLabel   matlab.ui.control.Label
        PrimaryTurnsEditField          matlab.ui.control.NumericEditField
        PrimaryTurnsEditFieldLabel     matlab.ui.control.Label
        VoltageonSecondarySideVsGauge  matlab.ui.control.SemicircularGauge
        VoltageonSecondarySideVsGaugeLabel  matlab.ui.control.Label
        VoltageonPrimarySideVpGauge    matlab.ui.control.SemicircularGauge
        VoltageonPrimarySideVpGaugeLabel  matlab.ui.control.Label
        Gauge                          matlab.ui.control.SemicircularGauge
        GaugeLabel                     matlab.ui.control.Label
        PolaritychangeButton           matlab.ui.control.StateButton
        Image                          matlab.ui.control.Image
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: PolaritychangeButton
        function PolaritychangeButtonValueChanged(app, event)
            app.PolaritychangeButton.Value = app.PolaritychangeButton.Value;
            SupplyVoltageEditFieldValueChanged(app, event)
        end

        % Value changed function: PrimaryTurnsEditField
        function PrimaryTurnsEditFieldValueChanged(app, event)
            app.PrimaryTurnsEditField.Value = app.PrimaryTurnsEditField.Value;
        end

        % Value changed function: SecondaryTurnsEditField
        function SecondaryTurnsEditFieldValueChanged(app, event)
            app.SecondaryTurnsEditField.Value = app.SecondaryTurnsEditField.Value;
        end

        % Value changed function: SupplyVoltageEditField
        function SupplyVoltageEditFieldValueChanged(app, event)
            value = app.SupplyVoltageEditField.Value;
            app.VoltageonPrimarySideVpGauge.Value = value;
            Np = app.PrimaryTurnsEditField.Value;
            Ns = app.SecondaryTurnsEditField.Value;
            app.VoltageonSecondarySideVsGauge.Value = int64((Ns/Np)*value);
            if app.PolaritychangeButton.Value
                app.TextArea_4.Value = '-';
                app.TextArea_2.Value = '+';
                app.Gauge.Value = app.VoltageonPrimarySideVpGauge.Value + app.VoltageonSecondarySideVsGauge.Value;
                fprintf('Voltage between primary and secondary %d\n', app.Gauge.Value);
                fprintf('!!!!AdditivePolarity!!!!\n')
            else
                app.TextArea_4.Value = '+';
                app.TextArea_2.Value = '-';
                app.Gauge.Value = app.VoltageonPrimarySideVpGauge.Value - app.VoltageonSecondarySideVsGauge.Value;
                fprintf('Voltage between primary and secondary %d\n', app.Gauge.Value);
                fprintf('!!!!SubtractivePolarity!!!!\n')
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [211 126 219 231];
            app.Image.ImageSource = fullfile(pathToMLAPP, 'download.png');

            % Create PolaritychangeButton
            app.PolaritychangeButton = uibutton(app.UIFigure, 'state');
            app.PolaritychangeButton.ValueChangedFcn = createCallbackFcn(app, @PolaritychangeButtonValueChanged, true);
            app.PolaritychangeButton.Text = 'Polarity change';
            app.PolaritychangeButton.Position = [46 50 130 46];

            % Create GaugeLabel
            app.GaugeLabel = uilabel(app.UIFigure);
            app.GaugeLabel.HorizontalAlignment = 'center';
            app.GaugeLabel.Position = [306 369 42 22];
            app.GaugeLabel.Text = 'Gauge';

            % Create Gauge
            app.Gauge = uigauge(app.UIFigure, 'semicircular');
            app.Gauge.Limits = [-300 300];
            app.Gauge.Position = [266 406 120 65];

            % Create VoltageonPrimarySideVpGaugeLabel
            app.VoltageonPrimarySideVpGaugeLabel = uilabel(app.UIFigure);
            app.VoltageonPrimarySideVpGaugeLabel.HorizontalAlignment = 'center';
            app.VoltageonPrimarySideVpGaugeLabel.Position = [29 207 163 22];
            app.VoltageonPrimarySideVpGaugeLabel.Text = 'Voltage on Primary Side (Vp) ';

            % Create VoltageonPrimarySideVpGauge
            app.VoltageonPrimarySideVpGauge = uigauge(app.UIFigure, 'semicircular');
            app.VoltageonPrimarySideVpGauge.Limits = [0 350];
            app.VoltageonPrimarySideVpGauge.Position = [50 244 120 65];

            % Create VoltageonSecondarySideVsGaugeLabel
            app.VoltageonSecondarySideVsGaugeLabel = uilabel(app.UIFigure);
            app.VoltageonSecondarySideVsGaugeLabel.BackgroundColor = [1 1 1];
            app.VoltageonSecondarySideVsGaugeLabel.HorizontalAlignment = 'center';
            app.VoltageonSecondarySideVsGaugeLabel.Position = [450 207 175 22];
            app.VoltageonSecondarySideVsGaugeLabel.Text = 'Voltage on Secondary Side (Vs)';

            % Create VoltageonSecondarySideVsGauge
            app.VoltageonSecondarySideVsGauge = uigauge(app.UIFigure, 'semicircular');
            app.VoltageonSecondarySideVsGauge.Limits = [0 350];
            app.VoltageonSecondarySideVsGauge.MajorTicks = [0 175 350];
            app.VoltageonSecondarySideVsGauge.Position = [478 244 120 65];

            % Create PrimaryTurnsEditFieldLabel
            app.PrimaryTurnsEditFieldLabel = uilabel(app.UIFigure);
            app.PrimaryTurnsEditFieldLabel.HorizontalAlignment = 'right';
            app.PrimaryTurnsEditFieldLabel.Position = [413 74 83 22];
            app.PrimaryTurnsEditFieldLabel.Text = 'Primary Turns ';

            % Create PrimaryTurnsEditField
            app.PrimaryTurnsEditField = uieditfield(app.UIFigure, 'numeric');
            app.PrimaryTurnsEditField.ValueChangedFcn = createCallbackFcn(app, @PrimaryTurnsEditFieldValueChanged, true);
            app.PrimaryTurnsEditField.Position = [511 74 100 22];

            % Create SecondaryTurnsEditFieldLabel
            app.SecondaryTurnsEditFieldLabel = uilabel(app.UIFigure);
            app.SecondaryTurnsEditFieldLabel.HorizontalAlignment = 'right';
            app.SecondaryTurnsEditFieldLabel.Position = [400 41 96 22];
            app.SecondaryTurnsEditFieldLabel.Text = 'Secondary Turns';

            % Create SecondaryTurnsEditField
            app.SecondaryTurnsEditField = uieditfield(app.UIFigure, 'numeric');
            app.SecondaryTurnsEditField.ValueChangedFcn = createCallbackFcn(app, @SecondaryTurnsEditFieldValueChanged, true);
            app.SecondaryTurnsEditField.Position = [511 41 100 22];

            % Create SupplyVoltageEditFieldLabel
            app.SupplyVoltageEditFieldLabel = uilabel(app.UIFigure);
            app.SupplyVoltageEditFieldLabel.HorizontalAlignment = 'right';
            app.SupplyVoltageEditFieldLabel.Position = [191 74 86 22];
            app.SupplyVoltageEditFieldLabel.Text = 'Supply Voltage';

            % Create SupplyVoltageEditField
            app.SupplyVoltageEditField = uieditfield(app.UIFigure, 'numeric');
            app.SupplyVoltageEditField.ValueChangedFcn = createCallbackFcn(app, @SupplyVoltageEditFieldValueChanged, true);
            app.SupplyVoltageEditField.Position = [292 74 100 22];

            % Create TextArea
            app.TextArea = uitextarea(app.UIFigure);
            app.TextArea.HorizontalAlignment = 'center';
            app.TextArea.FontSize = 24;
            app.TextArea.FontWeight = 'bold';
            app.TextArea.Position = [191 296 46 33];
            app.TextArea.Value = {'+'};

            % Create TextArea_2
            app.TextArea_2 = uitextarea(app.UIFigure);
            app.TextArea_2.HorizontalAlignment = 'center';
            app.TextArea_2.FontSize = 24;
            app.TextArea_2.FontWeight = 'bold';
            app.TextArea_2.Position = [405 154 46 33];
            app.TextArea_2.Value = {'-'};

            % Create TextArea_3
            app.TextArea_3 = uitextarea(app.UIFigure);
            app.TextArea_3.HorizontalAlignment = 'center';
            app.TextArea_3.FontSize = 24;
            app.TextArea_3.FontWeight = 'bold';
            app.TextArea_3.Position = [191 154 46 33];
            app.TextArea_3.Value = {'-'};

            % Create TextArea_4
            app.TextArea_4 = uitextarea(app.UIFigure);
            app.TextArea_4.HorizontalAlignment = 'center';
            app.TextArea_4.FontSize = 24;
            app.TextArea_4.FontWeight = 'bold';
            app.TextArea_4.Position = [405 296 46 33];
            app.TextArea_4.Value = {'+'};

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Single_Phase_Transformer_Polarity_test_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end