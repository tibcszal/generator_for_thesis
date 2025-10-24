package us.abstracta.jmeter.javadsl.sample;

import static org.assertj.core.api.Assertions.assertThat;
import static us.abstracta.jmeter.javadsl.JmeterDsl.*;

import java.io.IOException;
import java.time.Duration;
import org.junit.jupiter.api.Test;
import us.abstracta.jmeter.javadsl.core.TestPlanStats;

public class PerformanceTest {

  @Test
  public void testPerformance() throws IOException {
    TestPlanStats stats = testPlan(
        rpsThreadGroup()
            .maxThreads(300)
            .rampToAndHold(100, Duration.ofSeconds(5), Duration.ofSeconds(60))
            .children(
                httpSampler("http://127.0.0.1:8080")),
        // threadGroup(20, 10,
        // httpSampler("http://127.0.0.1:8080")),
        jtlWriter(System.getProperty("testOutputLocation")))
        .run();
    assertThat(stats.overall().sampleTimePercentile99()).isLessThan(Duration.ofSeconds(60));
  }
}