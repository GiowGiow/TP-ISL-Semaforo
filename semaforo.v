module semaforo(input clk, input rst, input bt,
	output reg [2:0] A, output reg [2:0] B);

	//Insira seu codigo aqui
	reg [1:0] state, nextState;
    reg [8:0] cnt;

    // Assíncrono: Seguinte estado
    always @(state, cnt) begin
      case(state)
      0:  // Cor Verde
        if (cnt == `VERDE) 
        	begin
        	  nextState = 1;
         	  cnt = 0;
        	end
        else nextState = 0;
      1:  // Cor Amarela
        if (cnt == `AMARELO) 
        	begin
        	  nextState = 2;
        	  cnt = 0;
        	end
        else nextState = 1;
      2:// Cor Vermelha
        if (cnt == `VERMELHO)
        	begin 
        	  nextState = 0;
        	  cnt = 0;
        	end
        else nextState = 2;
      default: nextState = 0;
      endcase
    end

    always @(negedge rst) begin
      cnt = 1;
      state = 0;
    end

    // Sincrona: Atualizacao do estado && Reset
    always @(posedge clk) begin
      state = nextState;
    end

    // Saidas
    always @(state) begin
      if(state == 0) A = 3'b 100; // Cor Verde
      else if(state == 1) A = 3'b 010; // Cor Amarela
      else A = 3'b 001; // Cor Vermelha
    end

    // Contador	
    always @(posedge clk) begin
	  cnt = cnt + 1;
	end

endmodule
	