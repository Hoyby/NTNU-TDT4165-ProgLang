declare RandomInt HammerFactory HammerConsumer BoundedBuffer in

% SubTask: A
    fun {RandomInt Min Max}
        X = {OS.rand}
        MinOS
        MaxOS 
    in
        {OS.randLimits ?MinOS ?MaxOS}
        Min + X*(Max - Min) div (MaxOS - MinOS)
    end

    fun lazy {HammerFactory}
        {Delay 1000}
        {Show 'Make Hammer!'}
        if {RandomInt 1 100} < 90 then
            working|{HammerFactory}
        else 
            defect|{HammerFactory}
        end
    end
    
    % % Test: A
    % local HammerTime B in
    %     HammerTime = {HammerFactory}
    %     B = HammerTime.2.2.2.1
    %     {System.show HammerTime}
    % end


% SubTask: B
    fun {HammerConsumer HammerStream N}
        if N > 0 then
            case HammerStream of working | Tail then
                1 + {HammerConsumer Tail N-1}
            [] defect | Tail then
                {HammerConsumer Tail N-1}
            end
        else 0 end
    end

    % % Test: B
    % local HammerTime Consumer in
    %     HammerTime = {HammerFactory}
    %     Consumer = {HammerConsumer HammerTime 10}
    %     {System.show Consumer}
    % end


% SubTask: C
    fun {BoundedBuffer HammerStream N}

        fun lazy {MakeHammer HammerStream PreMake} % Lazy creation of hammers
            case HammerStream of Head|Tail then 
                Head|{MakeHammer Tail thread PreMake.2 end} % Returns hammer, and calls the premake to make hammers for the buffer
            end
        end
    in 
        {MakeHammer HammerStream thread {List.drop HammerStream N} end} % Calls to make hammers on demand, while the thread forces a small buffer of N hammers
    end


    % Test: C
    local HammerStream Buffer Consumer in
        HammerStream = {HammerFactory} % Start the hammer factory
        Buffer = {BoundedBuffer HammerStream 6} % Init the buffer
        {System.showInfo "Sleep"}
        {Delay 6000} % Sleep for 6 seconds (6 hammers will be made during this time)
        {System.showInfo "Buffered"}
        Consumer = {HammerConsumer Buffer 10} % The consumer will resieve the 6 hammers that were made during sleep, 4 is made on-demand
        {System.show Consumer}
        % 6 seconds of sleep + 4 seconds of on-demand production = 10 seconds

    end
    
    local HammerStream Consumer in
        HammerStream = {HammerFactory} % Start the hammer factory
        {System.showInfo "Sleep"}
        {Delay 6000} % Sleep for 6 seconds (6 hammers will be made during this time)
        {System.showInfo "Not Buffered"}
        Consumer = {HammerConsumer HammerStream 10} % The consumer will resieve none of the hammers made during sleep, 10 is made on-demand
        {System.show Consumer}
        % 6 seconds of sleep + 10 seconds of on-demand production = 16 seconds
    end
