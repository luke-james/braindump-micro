package org.acme.rest

import io.quarkus.test.junit.QuarkusTest
import io.restassured.RestAssured.given
import org.hamcrest.CoreMatchers.`is`
import org.junit.jupiter.api.Test

@QuarkusTest
class BraindumpTest {

    @Test
    fun testHelloEndpoint() {
        given()
          .`when`().get("/braindump")
          .then()
             .statusCode(200)
             .body(`is`("Hello RESTEasy"))
    }

}