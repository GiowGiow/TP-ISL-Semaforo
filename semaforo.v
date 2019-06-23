module semaforo(input clk, input rst, input bt,
	output reg [2:0] A, output reg [2:0] B);

	//Insira seu codigo aqui
	reg [1:0] state, nextState;
    reg [8:0] cnt;

    // Assíncrono: Seguinte estado
    always @(state, cnt)
      case(state)
      0:  // Cor Vermelha
        if (cnt == `VERMELHO) nextState = 1;
        else nextState = 0;
      1:  // Cor Amarela
        if (cnt == `AMARELO) nextState = 2;
        else nextState = 1;
      2:  // Cor Verde
        if (cnt == `VERDE) nextState = 0;
        else nextState = 2;
      default: nextState = 0;
      endcase

    // Sincrona: Atualizacao do estado && Reset
    always @(posedge clk or negedge rst)
      if(rst == 0) state = 0;
      else state = nextState;

    // Saidas
    always @(state)
      if(state == 0) A = 3'b 001; // Cor Vermelha
      else if(state == 1) A = 3'b 010; // Cor Amarela
      else A = 3'b 100; // Cor Verde

    // Contador	
    always @(posedge clk or negedge rst)
      if(rst == 0) cnt = 0;
      else cnt = cnt + 1;
endmodule
	