namespace LyricsIdentity.Tests;

public class UnitTest1
{
    [Fact]
    public void Test1()
    {
        var forecast = new LyricsIdentity.WeatherForecast
        {
            TemperatureC = 0
        };

        Assert.Equal(32, forecast.TemperatureF);
    }
}
