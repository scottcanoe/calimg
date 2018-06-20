function seqSpecs = sequenceSpecs(seqType)

narginchk(1, 1);
if strcmp(seqType, 'ABCD') 

    EventValues = 0.0 : 0.2 : 3.0;
    Labels = {'-', ...
              '(A)B C D ', ' A(B)C D ', ' A B(C)D ', ' A B C(D)', '-', ...
              '(D)C D A ', ' D(C)B A ', ' D C(B)A ', ' D C B(A)', '-', ...
              '(A)B C D novT', ' A(B)C D novT', ' A B(C)D novT', ' A B C(D) novT', '-'};

    seqSpecs.EventValues = EventValues;
    seqSpecs.Labels = Labels;
elseif strcmp(seqType, 'random drifting gratings')
    EventValues = [0.0, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5];    
    Labels = {'-', ...
              '0-', '0+', ...
              '45-', '45+', ...
              '90-', '90+', ...
              '135-', '135+'};
else
    error(['Unknown sequence type "' seqType '"'] );
    
end
seqSpecs.EventValues = EventValues;
seqSpecs.Labels = Labels;
end