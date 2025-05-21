/*Questão 01. 
 *Crie um procedimento denominado salaryHistogram, que distribua as frequências dos salários dos Professores em intervalos (Histograma).
O número de intervalos será calculado de acordo com o parâmetro de entrada do procedimento. Exemplo: EXEC dbo.salaryHistogram 5;*/

CREATE PROCEDURE salaryHistogram @intervalo INT
AS
BEGIN
	DECLARE @sMin DECIMAL(10, 2), @sMax DECIMAL(10, 2);
	DECLARE @linhasSaida DECIMAL(10, 2), @diferenca DECIMAL(10, 2);
	DECLARE @i INT = 0;
	DECLARE @ValorMinimo DECIMAL(10, 2), @ValorMaximo DECIMAL(10, 2);

	SELECT @sMin = MIN(salary), @sMax = MAX(salary) FROM instructor;

	IF @sMin = @sMax
	BEGIN
		SELECT @sMin AS ValorMinimo, @sMax AS ValorMaximo, COUNT(*) AS Total
		FROM instructor;
		RETURN;
	END

	SET @diferenca = @sMax - @sMin;
	SET @linhasSaida =  @diferenca / @intervalo;

	CREATE TABLE #histograma (
		ValorMinimo DECIMAL(10, 2),
		ValorMaximo DECIMAL(10, 2),
		Total INT
	);

	WHILE @i < @intervalo
	BEGIN
		SET @ValorMinimo = @sMin + @linhasSaida * @i;
		SET @ValorMaximo = @ValorMinimo + @linhasSaida;
	
        IF @valorMaximo > @sMax
            SET @valorMaximo = @sMax;

		INSERT INTO #histograma (ValorMinimo, ValorMaximo, Total)
		SELECT @ValorMinimo, @ValorMaximo, COUNT(*)
		FROM instructor
		WHERE salary >= @ValorMinimo AND salary < @ValorMaximo;

		SET @i = @i + 1;
	END

    IF EXISTS (
        SELECT 1 FROM instructor
        WHERE salary = @sMax
        AND NOT EXISTS (
            SELECT 1 FROM #histograma
            WHERE @sMax >= valorMinimo AND @sMax < valorMaximo))
    BEGIN
        INSERT INTO #histograma (ValorMinimo, ValorMaximo, total)
        VALUES (@sMax, @sMax, (SELECT COUNT(*) FROM instructor WHERE salary = @sMax))
    END

    SELECT * FROM #histograma
    DROP TABLE #histograma
END


EXEC salaryHistogram 5;
