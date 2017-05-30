from kivent_core.systems.staticmemgamesystem cimport (StaticMemGameSystem, 
    MemComponent)
from kivent_particles.emitter cimport ParticleEmitter

ctypedef struct ParticleStruct:
    unsigned int entity_id
    float current_time
    float total_time
    float[2] start_pos
    float[2] velocity
    float radial_acceleration
    float tangential_acceleration
    float emit_radius
    float emit_radius_delta
    float emit_rotation
    float emit_rotation_delta
    float rotation_delta
    float scale_delta
    void* emitter
    float[4] color_delta
    float[4] color
    bint is_alive


cdef class ParticleComponent(MemComponent):
    pass


cdef class ParticleSystem(StaticMemGameSystem):
    cdef list _system_names
    cdef ParticleCacheBase cache
    cdef unsigned int create_particle(self, ParticleEmitter emitter) except -1
    cdef unsigned int tick
    
ctypedef struct CachedParticleInfo:
    unsigned int entity_id
    unsigned int components_index
    bint require_texture_change
    
cdef class ParticleCacheBase:
    cdef object gameworld 
    cdef short cache_particle(self, unsigned int entity_id,
                            unsigned int components_index,
                            unsigned int texkey,
                            unsigned int tick) except -1
    cdef CachedParticleInfo get_particle(self, unsigned int texture_key,
                                         unsigned int tick) except *
    cdef short remove_particle(self, unsigned int entity_id) except -1
    cdef short remove_particle_from_cache(self, unsigned int entity_id) except -1
    cdef int get_particle_count(self) except -1
    cdef do_maintenance_work(self, unsigned int tick)
    cdef tuple export_particles(self, bint do_clean)
    cdef list import_particles(self, list particles, unsigned int tick)
    
cdef class SimpleParticleCache(ParticleCacheBase):
    cdef unsigned int buffer_size
    cdef unsigned int available
    cdef dict texture_buffer
    cdef dict entity_buffer