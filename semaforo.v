`define true 1
`define false 0

module semaforo(input clk, input rst, input bt,
	output reg [2:0] A, output reg [2:0] B);

	reg [1:0] state, next_state;
    reg [8:0] cnt;

	reg [1:0] state_b;

    reg start_b = `false;
    reg ciclo = `false;
    reg follow_a = `false;

    // Assíncrono: seta o seguinte estado e reseta o contador
    always @(state, cnt) begin
      case(state)
      0: // Cor Verde
	    if (cnt == `VERDE) 
	    	begin
          // Se B ja estiver seguindo A, coloque como falso o bt
          if (follow_a) start_b = `false;
          // Semaforo B para de seguir A quando completa o cilo
	    	  follow_a = `false;
	    	  // Ciclo foi completado
          ciclo = `true;

	    	  next_state = 1; // Prox estado
	     	  cnt = 0; // Reseta o contador
	    	end
	    else next_state = 0;

	  1: // Cor Amarela
        begin
        // Ciclo em andamento
        ciclo = `false;
        if (cnt == `AMARELO) 
        	begin
        	  next_state = 2;
        	  cnt = 0;
        	end
        else next_state = 1;
        end
      2: // Cor Vermelha
        if (cnt == `VERMELHO)
        	begin 
        	  next_state = 0;
        	  cnt = 0;
        	end
        else next_state = 2;
      
      default: next_state = 0;
      endcase
    end

    // Quando tiver um reset (borda de descida)
    always @(negedge rst) begin
      cnt = 1; // Coloca contador em 1
      state = 0; // Coloca estado em 0
      state_b = 0;
      start_b = `false;
    end

    // Quando botao for acionado
    always @(posedge bt) begin
    	start_b = `true;
    end

    // Sincrono: Atualizacao do estado
    always @(posedge clk) begin
      state = next_state;
      // Se o botao foi apertado e comecou um ciclo entao
      // comece a seguir o semaforo A
      if(start_b == `true && ciclo == `true) begin
        start_b = `false;
        ciclo = `false;
        follow_a = `true;
      end
      if(follow_a)
      	state_b = state;
    end

    // Saidas
    always @(state) begin
      if(state == 0) 
      	begin
      	A = 3'b 100; // Cor Verde
      	end
      else if(state == 1) begin
        A = 3'b 010; // Cor Amarela
        end
      else begin
        A = 3'b 001; // Cor Vermelha
        end
    end

	always @(state_b) begin
      if(state_b == 0) 
      	begin
      	B = 3'b 100; // Cor Verde
      	end
      else if(state_b == 1) begin
        B = 3'b 010; // Cor Amarela
        end
      else begin
        B = 3'b 001; // Cor Vermelha
        end
    end

    // Contador	
    always @(posedge clk) begin
	  cnt = cnt + 1;
	end

endmodule
	