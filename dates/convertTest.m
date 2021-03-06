
%% Test convert with Frequency

dates = { yy(2000)
          hh(2000)
          qq(2000)
          mm(2000)
          ww(2000)
          dd(2000) };

freq = { Frequency.YEARLY
         Frequency.HALFYEARLY
         Frequency.QUARTERLY
         Frequency.MONTHLY
         Frequency.WEEKLY
         Frequency.DAILY };

num = { 1, 2, 4, 12, 52, 365 };

letters = { 'y', 'h', 'q', 'm', 'w', 'd' };

for d = 1 : numel(dates)
    for f = 1 : numel(freq)
        d1 = convert(dates{d}, freq{f});
        d2 = convert(dates{d}, num{f});
        d3 = convert(dates{d}, letters{f});
        check.equal( double(freq{f}), ...
                     DateWrapper.getFrequencyAsNumeric(d1) );
        check.equal( double(freq{f}), ...
                     DateWrapper.getFrequencyAsNumeric(d2) );
        check.equal( double(freq{f}), ...
                     DateWrapper.getFrequencyAsNumeric(d3) );
    end
end

