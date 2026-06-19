const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addLibrary(.{
        .name = "rdkafka",
        .linkage = .static,
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
        }),
    });

    lib.step.dependOn(&checkConfigH(b).step);

    const c_header = b.addConfigHeader(.{}, .{
        .SOLIB_EXT = ".so",
        .ENABLE_DEVEL = 0,
        .ENABLE_REGEX_EXT = 1,
        .HAVE_REGEX = 1,
        .ENABLE_LZ4_EXT = 1,
        .WITH_LZ4_EXT = 1,
        .WITH_LIBDL = 1,
        .WITH_PLUGINS = 1,
        .WITH_SSL = 1,
        .WITH_SASL_SCRAM = 1,
        .WITH_SASL_OAUTHBEARER = 1,
        .BUILT_WITH = "LIBDL PLUGINS LZ4_EXT SSL SASL_SCRAM SASL_OAUTHBEARER",
    });
    lib.root_module.addConfigHeader(c_header);

    lib.installHeadersDirectory(b.path("src"), "src", .{});

    lib.root_module.addIncludePath(b.path("src"));
    lib.root_module.addCSourceFiles(.{
        .files = src,
        .flags = build_flags,
    });

    lib.root_module.addIncludePath(b.path("src/opentelemetry"));
    lib.root_module.addCSourceFiles(.{
        .files = src_opentelemetry,
        .flags = build_flags,
    });

    lib.root_module.addIncludePath(b.path("src/nanopb"));
    lib.root_module.addCSourceFiles(.{
        .files = src_nanopb,
        .flags = build_flags,
    });

    b.installArtifact(lib);
}

const build_flags = &.{
    "-fno-sanitize=undefined",
    "-O3",
};

const src = &.{
    "src/rdkafka.c",
    "src/rdkafka_broker.c",
    "src/rdkafka_msg.c",
    "src/rdkafka_topic.c",
    "src/rdkafka_conf.c",
    "src/rdkafka_timer.c",
    "src/rdkafka_offset.c",
    "src/rdkafka_transport.c",
    "src/rdkafka_buf.c",
    "src/rdkafka_queue.c",
    "src/rdkafka_op.c",
    "src/rdkafka_request.c",
    "src/rdkafka_cgrp.c",
    "src/rdkafka_pattern.c",
    "src/rdkafka_partition.c",
    "src/rdkafka_subscription.c",
    "src/rdkafka_assignment.c",
    "src/rdkafka_assignor.c",
    "src/rdkafka_range_assignor.c",
    "src/rdkafka_roundrobin_assignor.c",
    "src/rdkafka_sticky_assignor.c",
    "src/rdkafka_feature.c",
    "src/rdkafka_mock.c",
    "src/rdkafka_mock_handlers.c",
    "src/rdkafka_mock_cgrp.c",
    "src/rdkafka_error.c",
    "src/rdkafka_fetcher.c",
    "src/rdkafka_telemetry.c",
    "src/rdkafka_telemetry_encode.c",
    "src/rdkafka_telemetry_decode.c",
    "src/rdkafka_sasl_cyrus.c",
    "src/rdkafka_sasl_scram.c",
    "src/rdkafka_sasl_oauthbearer.c",
    "src/rdcrc32.c",
    "src/crc32c.c",
    "src/rdmurmur2.c",
    "src/rdfnv1a.c",
    "src/cJSON.c",
    "src/rdaddr.c",
    "src/rdrand.c",
    "src/rdlist.c",
    "src/tinycthread.c",
    "src/tinycthread_extra.c",
    "src/rdlog.c",
    "src/rdstring.c",
    "src/rdkafka_event.c",
    "src/rdkafka_metadata.c",
    "src/rdregex.c",
    "src/rdports.c",
    "src/rdkafka_metadata_cache.c",
    "src/rdavl.c",
    "src/rdkafka_sasl.c",
    "src/rdkafka_sasl_plain.c",
    "src/rdkafka_interceptor.c",
    "src/rdkafka_msgset_writer.c",
    "src/rdkafka_msgset_reader.c",
    "src/rdkafka_header.c",
    "src/rdkafka_admin.c",
    "src/rdkafka_aux.c",
    "src/rdkafka_background.c",
    "src/rdkafka_idempotence.c",
    "src/rdkafka_cert.c",
    "src/rdkafka_txnmgr.c",
    "src/rdkafka_coord.c",
    "src/rdbase64.c",
    "src/rdvarint.c",
    "src/rdbuf.c",
    "src/rdmap.c",
    "src/rdunittest.c",
    "src/snappy.c",
    "src/rdgz.c",
    "src/rdhdrhistogram.c",
    "src/rdkafka_ssl.c",
    "src/rdkafka_lz4.c",
    "src/rdxxhash.c",
    "src/rddl.c",
    "src/rdkafka_plugin.c",
};

const src_nanopb = &.{
    "src/nanopb/pb_encode.c",
    "src/nanopb/pb_decode.c",
    "src/nanopb/pb_common.c",
};

const src_opentelemetry = &.{
    "src/opentelemetry/metrics.pb.c",
    "src/opentelemetry/common.pb.c",
    "src/opentelemetry/resource.pb.c",
};

fn checkConfigH(b: *std.Build) *std.Build.Step.CheckFile {
    return b.addCheckFile(
        b.path("src/tinycthread.h"),
        .{ .expected_matches = &.{"#include \"config.h\""} },
    );
}
