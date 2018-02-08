function tests = startDateTest( )
tests = functiontests(localfunctions);
end
%#ok<*DEFNU>


function setupOnce(this)
    range = qq(2000, 1):qq(2015, 4);
    d = struct( );
    d.x = hpf2(cumsum(Series(range, @randn)));
    d.y = hpf2(cumsum(Series(range, @randn)));
    d.z = hpf2(cumsum(Series(range, @randn)));
    d.a = hpf2(cumsum(Series(range, @randn)));
    d.b = hpf2(cumsum(Series(range, @randn)));
    v = VAR( {'x', 'y', 'z'} );
    [v, vd] = estimate(v, d, range, 'Order=', 2);
    this.TestData.range = range;
    this.TestData.v = v;
    this.TestData.d = d;
    this.TestData.vd = vd;
end


function testEfronBootstrap(this)
    v = this.TestData.v;
    d = this.TestData.d;
    vd = this.TestData.vd;
    range = this.TestData.range;
    order = get(v, 'Order');
    numDraws = 10;
    [bootD, draw] = resample(v, vd, range(order+1:end), numDraws, 'Method=', 'Bootstrap');
    res_x = vd.res_x(:, 1);
    res_y = vd.res_y(:, 1);
    res_z = vd.res_z(:, 1);
    for v = 1 : numDraws
        perm = draw(:, v);
        assertEqual(this, bootD.res_x(:, v), res_x(perm));
        assertEqual(this, bootD.res_y(:, v), res_y(perm));
        assertEqual(this, bootD.res_z(:, v), res_z(perm));
    end
end



function testWildBootstrap(this)
    v = this.TestData.v;
    d = this.TestData.d;
    vd = this.TestData.vd;
    range = this.TestData.range;
    order = get(v, 'Order');
    numDraws = 10;
    [bootD, draw] = resample(v, vd, range(order+1:end), numDraws, 'Method=', 'Bootstrap', 'Wild=', true);
    for v = 1 : numDraws
        assertEqual(this, bootD.res_x(:, v), vd.res_x(:, 1).*draw(:, v));
        assertEqual(this, bootD.res_y(:, v), vd.res_y(:, 1).*draw(:, v));
        assertEqual(this, bootD.res_z(:, v), vd.res_z(:, 1).*draw(:, v));
    end
end

