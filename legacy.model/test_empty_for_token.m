
%% Test Empty Token in For

m = model('test_empty_for_token.model');
list = get(m, 'XList');
assert(isequal(list, {'x', 'xF', 'xG'}));

%% Test Empty Token in For with Old Syntax

m = model('test_empty_for_token_old_syntax.model');
list = get(m, 'XList');
assert(isequal(list, {'y', 'yF', 'yG'}));


