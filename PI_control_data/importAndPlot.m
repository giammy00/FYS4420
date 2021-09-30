function [cm, T, V, fig] = importAndPlot(file_name)
%IMPORT AND PLOT: imports pi control measurement data
%   Useful tool to import data from experiments

load(file_name) ; 
plfig = true; 
disp(['Loading and plotting data in ', file_name]) ; 
T = remove_zeros(T) ; %removing zero elements, if present
cm = cm(1:numel(T)) ; 

if plfig 
    fig = figure('color' , [ 1 1 1 ] );
    plot( cm, T, 'linestyle', 'none' , 'marker' , '.' ) ;
    grid on ;
    xlabel ( 't ( seconds )' , 'fontsize' , 14 ) ;
    ylabel( 'T ( kelvin ) ' , 'fontsize', 14 ) ; 
end 

end

