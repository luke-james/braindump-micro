package org.acme.rest.resteasyjackson

import org.acme.rest.Fruit

import javax.ws.rs.DELETE
import javax.ws.rs.GET
import javax.ws.rs.POST
import javax.ws.rs.Path

/**
 * This class will be our Quarkus endpoint for Fruit requests.
 */
@Path(value = "/fruits")
class FruitResource constructor(){

    private var fruits = LinkedHashSet<Fruit>()

    init {

        fruits.add(Fruit(name = "apple", description = "A red, round fruit.  Can sometimes be green..."))
        fruits.add(Fruit(name = "orange", description = "A zesty round fruit."))

    }

    @GET
    fun list(): Set<Fruit> = fruits.toSet()

    @POST
    fun add(fruit: Fruit): Set<Fruit> {
        fruits.add(fruit)
        return fruits.toSet()
    }

    @DELETE
    fun delete(fruit: Fruit): Set<Fruit> {
        fruits.removeIf { fruitToRemove -> fruitToRemove.name == fruit.name }
        return fruits.toSet()
    }

}