package com.hazelcast.guide;

import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.inject.Produces;
import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.hazelcast.config.Config;
import com.hazelcast.config.MapConfig;
import com.hazelcast.core.Hazelcast;
import com.hazelcast.core.HazelcastInstance;

@ApplicationPath("application")
@ApplicationScoped
public class HazelcastApplication extends Application {

    static String MAP_NAME = "guide-map";

    @Produces
    HazelcastInstance create() {
        Config config = new Config();
        // all other configurations (networking,
        // listeners, etc.) can be set here.
        MapConfig mapConfig = new MapConfig();
        mapConfig.setName(MAP_NAME);
        mapConfig.setTimeToLiveSeconds(30);
        config.addMapConfig(mapConfig);
        return Hazelcast.newHazelcastInstance(config);
    }
}
