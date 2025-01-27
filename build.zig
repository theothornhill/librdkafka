const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addStaticLibrary(.{
        .name = "rdkafka",
        .target = target,
        .optimize = optimize,
    });

    const configure = b.addSystemCommand(&.{
        "./configure",
    });

    lib.step.dependOn(&configure.step);
    b.getInstallStep().dependOn(&configure.step);

    lib.installHeadersDirectory(
        b.path("src"),
        "src",
        .{},
    );

    lib.addIncludePath(b.path("src"));
    lib.addCSourceFiles(.{
        .root = b.path("src"),
        .files = src,
        .flags = build_flags,
    });

    lib.addIncludePath(b.path("src/opentelemetry"));
    lib.addCSourceFiles(.{
        .root = b.path("src/opentelemetry"),
        .files = src_opentelemetry,
        .flags = build_flags,
    });

    lib.addIncludePath(b.path("src/nanopb"));
    lib.addCSourceFiles(.{
        .root = b.path("src/nanopb"),
        .files = src_nanopb,
        .flags = build_flags,
    });

    b.installArtifact(lib);
}

const build_flags = &.{
    "-std=gnu90",
    "-s",
    "-O3",
};

const src = &.{
    "rdkafka.c",
    "rdkafka_broker.c",
    "rdkafka_msg.c",
    "rdkafka_topic.c",
    "rdkafka_conf.c",
    "rdkafka_timer.c",
    "rdkafka_offset.c",
    "rdkafka_transport.c",
    "rdkafka_buf.c",
    "rdkafka_queue.c",
    "rdkafka_op.c",
    "rdkafka_request.c",
    "rdkafka_cgrp.c",
    "rdkafka_pattern.c",
    "rdkafka_partition.c",
    "rdkafka_subscription.c",
    "rdkafka_assignment.c",
    "rdkafka_assignor.c",
    "rdkafka_range_assignor.c",
    "rdkafka_roundrobin_assignor.c",
    "rdkafka_sticky_assignor.c",
    "rdkafka_feature.c",
    "rdkafka_mock.c",
    "rdkafka_mock_handlers.c",
    "rdkafka_mock_cgrp.c",
    "rdkafka_error.c",
    "rdkafka_fetcher.c",
    "rdkafka_telemetry.c",
    "rdkafka_telemetry_encode.c",
    "rdkafka_telemetry_decode.c",
    "rdkafka_sasl_cyrus.c",
    "rdkafka_sasl_scram.c",
    "rdkafka_sasl_oauthbearer.c",
    "rdcrc32.c",
    "crc32c.c",
    "rdmurmur2.c",
    "rdfnv1a.c",
    "cJSON.c",
    "rdaddr.c",
    "rdrand.c",
    "rdlist.c",
    "tinycthread.c",
    "tinycthread_extra.c",
    "rdlog.c",
    "rdstring.c",
    "rdkafka_event.c",
    "rdkafka_metadata.c",
    "rdregex.c",
    "rdports.c",
    "rdkafka_metadata_cache.c",
    "rdavl.c",
    "rdkafka_sasl.c",
    "rdkafka_sasl_plain.c",
    "rdkafka_interceptor.c",
    "rdkafka_msgset_writer.c",
    "rdkafka_msgset_reader.c",
    "rdkafka_header.c",
    "rdkafka_admin.c",
    "rdkafka_aux.c",
    "rdkafka_background.c",
    "rdkafka_idempotence.c",
    "rdkafka_cert.c",
    "rdkafka_txnmgr.c",
    "rdkafka_coord.c",
    "rdbase64.c",
    "rdvarint.c",
    "rdbuf.c",
    "rdmap.c",
    "rdunittest.c",
    "snappy.c",
    "rdgz.c",
    "rdhdrhistogram.c",
    "rdkafka_ssl.c",
    "rdkafka_lz4.c",
    "rdxxhash.c",
    "rddl.c",
    "rdkafka_plugin.c",
};

const src_nanopb = &.{
    "pb_encode.c",
    "pb_decode.c",
    "pb_common.c",
};

const src_opentelemetry = &.{
    "metrics.pb.c",
    "common.pb.c",
    "resource.pb.c",
};
