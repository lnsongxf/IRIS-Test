function Tests = modelParserTest()
Tests = functiontests(localfunctions);
end
%#ok<*DEFNU>


function testQuotes(this)
m = model('testQuotes.model');
% Descriptions of variables.
actDescript = get(m, 'description');
expDescript = struct( ...
    'x', 'Variable x', ...
    'y', 'Variable y', ...
    'z', 'Variable z', ...
    'ttrend', 'Time trend' ...
);
verifyEqual(this, actDescript, expDescript);
% Equation labels.
actLabel = get(m,'label');
expLabel = {
    'Equation x'
    'Equation y'
    'Equation z'
};
verifyEqual(this, actLabel, expLabel);
end


function testForControlInQuotes(this)
m = model('testForControlInQuotes.model');
expLabel = {
    'Equation for X'
    'Equation for Y'
    'Equation for Z'
};
actLabel = get(m,'labels');
assertEqual(this,actLabel,expLabel);
end


function testBracketsInQuotes(this)
m = model('testBracketsInQuotes.model');
% Descriptions of variables.
actDescript = get(m,'description');
expDescript = struct( ...
    'x','Variable x ([%])', ...
    'y','(Variable y)', ...
    'z','Variable z', ...
    'ttrend', 'Time trend' ...
);
verifyEqual(this,actDescript,expDescript);
% Equation labels.
actLabel = get(m,'label');
expLabel = { 
    '[Equation x](('
    '{Equation {y'
    'Equation} z}'
};
verifyEqual(this,actLabel,expLabel);
end


function testAssignments(this)
m = model('testAssignment.model');
% Values assigned to variables in model file.
actAssign = get(m,'sstate');
expAssign = struct( ...
    'x',(1 + 2) + 1i, ...
    'y',complex(3*normpdf(2,1,0.5),2), ...
    'z',[1,2,3]*[4,5,6]', ...
    'ttrend', 0+1i ...
);
verifyEqual(this,actAssign,expAssign);
end


function testMultipleAssignments(this)
m = model('testMultipleAssignment.model');
% Values assigned to variables in model file.
actAssign = get(m, 'sstate');
expAssign = struct( ...
    'x', [1,2,3], ...
    'y', [4,5,6], ...
    'z', [1,1,1], ...
    'w', [NaN,NaN,NaN], ...
    'alp', [10,10,10], ...
    'bet', sin([1,2,3]), ...
    'ttrend', repmat(0+1i, 1, 3) ...
);
assertEqual(this, actAssign, expAssign);
end


function testAutoexogenize(this)
m = model('testAutoexogenize.model');
% Values assigned to variables in model file.
actAutoexog = autoexog(m);
expAutoexog = struct( );
expAutoexog.Dynamic = struct( ...
    'x', 'ex', ...
    'y', 'ey', ...
    'z', 'ez', ...
    'w', 'ew' ...
    );
expAutoexog.Steady = struct( );
assertEqual(this, actAutoexog, expAutoexog);

actAutoexog = autoexogenise(m);
expAutoexog = struct( ...
    'x', 'ex', ...
    'y', 'ey', ...
    'z', 'ez', ...
    'w', 'ew' ...
    );
assertEqual(this, actAutoexog, expAutoexog);
end




function testEvalTimeSubs(this)
eqtn = { ...
    'x{-1+1} - y{0} + z{-4} + x{10+10}', ...
    'x{0} + y{-0} + z{-0+1-1}', ...
    'x{0} + y{+-5} + z{+1}', ...
    'x{t-1} + y{t+4-4} + z{t+10}', ...
    'x{0}', ...
    };
[actEqtn, actMaxSh, actMinSh] = parser.theparser.Equation.evalTimeSubs(eqtn);
actEqtn = parser.Preparser.removeInsignificantWhs(actEqtn);

expEqtn = { ...
    'x - y + z{@-4} + x{@+20}', ...
    'x + y + z', ...
    'x + y{@-5} + z{@+1}', ...
    'x{@-1} + y + z{@+10}', ...
    'x', ...
};
expEqtn = parser.Preparser.removeInsignificantWhs(expEqtn);

expMaxSh = 20;
expMinSh = -5;

assertEqual(this, actEqtn, expEqtn);
assertEqual(this, actMaxSh, expMaxSh);
assertEqual(this, actMinSh, expMinSh);
end
