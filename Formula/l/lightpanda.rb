class Lightpanda < Formula
  desc "Headless browser designed for AI and automation"
  homepage "https://github.com/lightpanda-io/browser"
  url "https://github.com/lightpanda-io/browser/archive/refs/tags/v0.2.6.tar.gz"
  sha256 "76e2476f105fd3f7fa1cba7f0a43ca264043733148b725f0e0f1f2385506c6a6"
  license "AGPL-3.0-or-later"
  head "https://github.com/lightpanda-io/browser.git", branch: "main"

  depends_on "rust" => :build
  depends_on "zig" => :build

  resource "lightpanda-v8-source" do
    url "https://github.com/lightpanda-io/zig-v8-fork/archive/refs/tags/v0.3.3.tar.gz"
    sha256 "aab25cc9c479215afe21d2cb0007b6cdfcd6d8cb501441553f60b96bb2dba02b"
  end

  if OS.mac? && Hardware::CPU.arm?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_macos_aarch64.a"
      sha256 "c9fb1286e07447d097a704d5ff1b305172f359796e20aaf132deee2d502acca0"
    end
  elsif OS.mac? && Hardware::CPU.intel?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_macos_x86_64.a"
      sha256 "ea2037790c93bb45e8156219fb44638bb9f10ed6cbd988b62d88d39204b40167"
    end
  elsif OS.linux? && Hardware::CPU.arm?
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_linux_aarch64.a"
      sha256 "1427c46de6da4918597640a720e2ba725410f41dcac57626291dd025a5968f69"
    end
  else
    resource "libc_v8" do
      url "https://github.com/lightpanda-io/zig-v8-fork/releases/download/v0.3.3/libc_v8_14.0.365.4_linux_x86_64.a"
      sha256 "b875439b3df025a2da510388559fe66c4454ed660bc38101c54dd55af0b5d0c7"
    end
  end

  ZIG_DEPS = {
    "brotli"        => {
      url:    "https://github.com/google/brotli/archive/028fb5a23661f123017c060daa546b55cf4bde29.tar.gz",
      sha256: "0afe09a53c8bad9861c8dd1fc1284308d54f19d2979ba3541cfdcc9b05fe360f",
    },
    "zlib"          => {
      url:    "https://github.com/madler/zlib/releases/download/v1.3.2/zlib-1.3.2.tar.gz",
      sha256: "bb329a0a2cd0274d05519d61c667c062e06990d72e125ee2dfa8de64f0119d16",
    },
    "nghttp2"       => {
      url:    "https://github.com/nghttp2/nghttp2/releases/download/v1.68.0/nghttp2-1.68.0.tar.gz",
      sha256: "2c16ffc588ad3f9e2613c3fad72db48ecb5ce15bc362fcc85b342e48daf51013",
    },
    "boringssl-zig" => {
      url:    "https://github.com/Syndica/boringssl-zig/archive/c53df00d06b02b755ad88bbf4d1202ed9687b096.tar.gz",
      sha256: "60b25deedd68d5c424682db1160d2a192376c05f85b4d98a2ad1f3536dfd4037",
    },
    "curl"          => {
      url:    "https://github.com/curl/curl/releases/download/curl-8_18_0/curl-8.18.0.tar.gz",
      sha256: "e9274a5f8ab5271c0e0e6762d2fce194d5f98acc568e4ce816845b2dcc0cf88f",
    },
  }.freeze

  CARGO_CRATES = [
    ["autocfg", "1.4.0", "ace50bade8e6234aa140d9a2f552bbee1db4d353f69b8217bc503490fc1a9f26"],
    ["bitflags", "2.9.1", "1b8e56985ec62d17e9c1001dc89c88ecd7dc08e47eba5ec7c29c7b5eeecde967"],
    ["cc", "1.2.39", "e1354349954c6fc9cb0deab020f27f783cf0b604e8bb754dc4658ecf0d29c35f"],
    ["cfg-if", "1.0.0", "baf1de4339761588bc0619e3cbc0120ee582ebb74b53b4efbf79117bd2da40fd"],
    ["find-msvc-tools", "0.1.2", "1ced73b1dacfc750a6db6c0a0c3a3853c8b41997e2e2c563dc90804ae6867959"],
    ["futf", "0.1.5", "df420e2e84819663797d1ec6544b13c5be84629e7bb00dc960d6917db2987843"],
    ["html5ever", "0.35.0", "55d958c2f74b664487a2035fe1dadb032c48718a03b63f3ab0b8537db8549ed4"],
    ["libc", "0.2.172", "d750af042f7ef4f724306de029d18836c26c1765a54a6a3f094cbd23a7267ffa"],
    ["lock_api", "0.4.13", "96936507f153605bddfcda068dd804796c84324ed2510809e5b2a624c81da765"],
    ["log", "0.4.27", "13dc2df351e3202783a1fe0d44375f7295ffb4049267b0f3018346dc122a1d94"],
    ["mac", "0.1.1", "c41e0c4fef86961ac6d6f8a82609f55f31b05e4fce149ac5710e439df7619ba4"],
    ["markup5ever", "0.35.0", "311fe69c934650f8f19652b3946075f0fc41ad8757dbb68f1ca14e7900ecc1c3"],
    ["match_token", "0.35.0", "ac84fd3f360fcc43dc5f5d186f02a94192761a080e8bc58621ad4d12296a58cf"],
    ["new_debug_unreachable", "1.0.6", "650eef8c711430f1a879fdd01d4745a7deea475becfb90269c06775983bbf086"],
    ["parking_lot", "0.12.4", "70d58bf43669b5795d1576d0641cfb6fbb2057bf629506267a92807158584a13"],
    ["parking_lot_core", "0.9.11", "bc838d2a56b5b1a6c25f55575dfc605fabb63bb2365f6c2353ef9159aa69e4a5"],
    ["paste", "1.0.15", "57c0d7b74b563b49d38dae00a0c37d4d6de9b432382b2892f0574ddcae73fd0a"],
    ["phf", "0.11.3", "1fd6780a80ae0c52cc120a26a1a42c1ae51b247a253e4e06113d23d2c2edd078"],
    ["phf_codegen", "0.11.3", "aef8048c789fa5e851558d709946d6d79a8ff88c0440c587967f8e94bfb1216a"],
    ["phf_generator", "0.11.3", "3c80231409c20246a13fddb31776fb942c38553c51e871f8cbd687a4cfb5843d"],
    ["phf_shared", "0.11.3", "67eabc2ef2a60eb7faa00097bd1ffdb5bd28e62bf39990626a582201b7a754e5"],
    ["phf_shared", "0.13.1", "e57fef6bc5981e38c2ce2d63bfa546861309f875b8a75f092d1d54ae2d64f266"],
    ["precomputed-hash", "0.1.1", "925383efa346730478fb4838dbe9137d2a47675ad789c546d150a6e1dd4ab31c"],
    ["proc-macro2", "1.0.95", "02b3e5e68a3a1a02aad3ec490a98007cbc13c37cbe84a3cd7b8e406d76e7f778"],
    ["quote", "1.0.40", "1885c039570dc00dcb4ff087a89e185fd56bae234ddc7f056a945bf36467248d"],
    ["rand", "0.8.5", "34af8d1a0e25924bc5b7c43c079c942339d8f0a8b57c39049bef581b46327404"],
    ["rand_core", "0.6.4", "ec0be4795e2f6a28069bec0b5ff3e2ac9bafc99e6a9a7dc3547996c5c816922c"],
    ["redox_syscall", "0.5.12", "928fca9cf2aa042393a8325b9ead81d2f0df4cb12e1e24cef072922ccd99c5af"],
    ["scopeguard", "1.2.0", "94143f37725109f92c262ed2cf5e59bce7498c01bcc1502d7b9afe439a4e9f49"],
    ["serde", "1.0.219", "5f0e2c6ed6606019b4e29e69dbaba95b11854410e5347d525002456dbbb786b6"],
    ["serde_derive", "1.0.219", "5b0276cf7f2c73365f7157c8123c21cd9a50fbbd844757af28ca1f5925fc2a00"],
    ["shlex", "1.3.0", "0fda2ff0d084019ba4d7c6f371c95d8fd75ce3524c3cb8fb653a3023f6323e64"],
    ["siphasher", "1.0.1", "56199f7ddabf13fe5074ce809e7d3f42b42ae711800501b5b16ea82ad029c39d"],
    ["smallvec", "1.15.1", "67b1b7a3b5fe4f1376887184045fcf45c69e92af734b7aaddc05fb777b6fbd03"],
    ["string_cache", "0.8.9", "bf776ba3fa74f83bf4b63c3dcbbf82173db2632ed8452cb2d891d33f459de70f"],
    ["string_cache", "0.9.0", "a18596f8c785a729f2819c0f6a7eae6ebeebdfffbfe4214ae6b087f690e31901"],
    ["string_cache_codegen", "0.5.4", "c711928715f1fe0fe509c53b43e993a9a557babc2d0a3567d0a3006f1ac931a0"],
    ["syn", "2.0.101", "8ce2b7fc941b3a24138a0a7cf8e858bfc6a992e7978a068a5c760deb0ed43caf"],
    ["tendril", "0.4.3", "d24a120c5fc464a3458240ee02c299ebcb9d67b5249c8848b09d639dca8d7bb0"],
    ["tikv-jemalloc-ctl", "0.6.0", "f21f216790c8df74ce3ab25b534e0718da5a1916719771d3fec23315c99e468b"],
    ["tikv-jemalloc-sys", "0.6.0+5.3.0-1-ge13ca993e8ccb9b" \
                          "a9847cc330696e02839f328f7",
     "cd3c60906412afa9c2b5b5a48ca6a5abe5736aec9eb48ad05037a677e52e4e2d"],
    ["tikv-jemallocator", "0.6.0", "4cec5ff18518d81584f477e9bfdf957f5bb0979b0bac3af4ca30b5b3ae2d2865"],
    ["typed-arena", "2.0.2", "6af6ae20167a9ece4bcb41af5b80f8a1f1df981f6391189ce00fd257af04126a"],
    ["unicode-ident", "1.0.18", "5a5f39404a5da50712a4c1eecf25e90dd62b613502b7e925fd4e4d19b5c96512"],
    ["utf-8", "0.7.6", "09cc8ee72d2a9becf2f2febe0205bbed8fc6615b7cb429ad062dc7b7ddd036a9"],
    ["web_atoms", "0.1.3", "57ffde1dc01240bdf9992e3205668b235e59421fd085e8a317ed98da0178d414"],
    ["windows-targets", "0.52.6", "9b724f72796e036ab90c1021d4780d4d3d648aca59e491e6b98e725b84e99973"],
    ["windows_aarch64_gnullvm", "0.52.6", "32a4622180e7a0ec044bb555404c800bc9fd9ec262ec147edd5989ccd0c02cd3"],
    ["windows_aarch64_msvc", "0.52.6", "09ec2a7bb152e2252b53fa7803150007879548bc709c039df7627cabbd05d469"],
    ["windows_i686_gnu", "0.52.6", "8e9b5ad5ab802e97eb8e295ac6720e509ee4c243f69d781394014ebfe8bbfa0b"],
    ["windows_i686_gnullvm", "0.52.6", "0eee52d38c090b3caa76c563b86c3a4bd71ef1a819287c19d586d7334ae8ed66"],
    ["windows_i686_msvc", "0.52.6", "240948bc05c5e7c6dabba28bf89d89ffce3e303022809e73deaefe4f6ec56c66"],
    ["windows_x86_64_gnu", "0.52.6", "147a5c80aabfbf0c7d901cb5895d1de30ef2907eb21fbbab29ca94c5b08b1a78"],
    ["windows_x86_64_gnullvm", "0.52.6", "24d5b23dc417412679681396f2b49f3de8c1473deb516bd34410872eff51ed0d"],
    ["windows_x86_64_msvc", "0.52.6", "589f6da84c646204747d1270a2a5661ea66ed1cced2631d546fdfb155959f9ec"],
    ["xml5ever", "0.35.0", "ee3f1e41afb31a75aef076563b0ad3ecc24f5bd9d12a72b132222664eb76b494"],
  ].freeze

  ZIG_DEPS.each do |name, spec|
    resource name do
      url spec[:url]
      sha256 spec[:sha256]
    end
  end

  CARGO_CRATES.each do |name, crate_version, checksum|
    resource "#{name}-#{crate_version}" do
      url "https://crates.io/api/v1/crates/#{name}/#{crate_version}/download"
      sha256 checksum
    end
  end

  def install
    deps_dir = buildpath/"deps"
    deps_dir.mkpath
    stage_lightpanda_v8(deps_dir)
    stage_zig_dependencies(deps_dir)
    vendor_cargo_dependencies
    rewrite_build_zon

    ENV["CARGO_HOME"] = buildpath/"cargo-home"
    ENV["CARGO_NET_OFFLINE"] = "true"
    ENV["LIGHTPANDA_DISABLE_TELEMETRY"] = "true"
    ENV["ZIG_GLOBAL_CACHE_DIR"] = buildpath/"zig-global-cache"
    ENV["ZIG_LOCAL_CACHE_DIR"] = buildpath/"zig-local-cache"

    zig = Formula["zig"].opt_bin/"zig"
    prebuilt_v8 = deps_dir/"v8/libc_v8.a"
    snapshot_path = buildpath/"src/snapshot.bin"

    system zig, "build", "-Doptimize=ReleaseFast",
                "-Dprebuilt_v8_path=#{prebuilt_v8}",
                "snapshot_creator", "--", snapshot_path
    system zig, "build", "-Doptimize=ReleaseFast",
                "-Dsnapshot_path=#{snapshot_path}",
                "-Dprebuilt_v8_path=#{prebuilt_v8}",
                "-Dgit_commit=v#{version}"

    bin.install "zig-out/bin/lightpanda"
  end

  def stage_lightpanda_v8(deps_dir)
    resource("lightpanda-v8-source").stage do
      target = deps_dir/"v8"
      target.mkpath
      cp_r Dir["*"] + Dir[".*"] - %w[. ..], target

      build_zon = target/"build.zig.zon"
      build_zon_content = build_zon.read
      unless build_zon_content.sub!(
        /    \.dependencies = \.\{\n.*?    \},\n(?=    \.paths = \.\{)/m,
        "    .dependencies = .{},\n",
      )
        odie "Failed to rewrite zig-v8-fork dependency stanza"
      end
      build_zon_content.gsub!("\"README\",", "\"README.md\",")
      build_zon.atomic_write build_zon_content
    end

    cp resource("libc_v8").cached_download, deps_dir/"v8/libc_v8.a"
  end

  def stage_zig_dependencies(deps_dir)
    ZIG_DEPS.each_key do |name|
      resource(name).stage do
        target = deps_dir/name
        target.mkpath
        cp_r Dir["*"] + Dir[".*"] - %w[. ..], target
      end
    end
  end

  def vendor_cargo_dependencies
    vendor_dir = buildpath/"cargo-vendor"
    vendor_dir.mkpath

    CARGO_CRATES.each do |name, crate_version, checksum|
      resource("#{name}-#{crate_version}").stage do
        target = vendor_dir/"#{name}-#{crate_version}"
        target.mkpath
        cp_r Dir["*"] + Dir[".*"] - %w[. ..], target
        (target/".cargo-checksum.json").write <<~JSON
          {"package":"#{checksum}","files":{}}
        JSON
      end
    end

    cargo_config_dir = buildpath/".cargo"
    cargo_config_dir.mkpath
    (cargo_config_dir/"config.toml").write <<~TOML
      [source.crates-io]
      replace-with = "vendored-sources"

      [source.vendored-sources]
      directory = "#{vendor_dir}"
    TOML
  end

  def rewrite_build_zon
    (buildpath/"build.zig.zon").atomic_write <<~ZIG
      .{
          .name = .browser,
          .version = "0.0.0",
          .fingerprint = 0xda130f3af836cea0,
          .minimum_zig_version = "0.15.2",
          .dependencies = .{
              .v8 = .{ .path = "deps/v8" },
              .brotli = .{ .path = "deps/brotli" },
              .zlib = .{ .path = "deps/zlib" },
              .nghttp2 = .{ .path = "deps/nghttp2" },
              .@"boringssl-zig" = .{ .path = "deps/boringssl-zig" },
              .curl = .{ .path = "deps/curl" },
          },
          .paths = .{""},
      }
    ZIG
  end

  test do
    ENV["LIGHTPANDA_DISABLE_TELEMETRY"] = "true"

    assert_match version.to_s, shell_output("#{bin}/lightpanda version 2>&1")

    port = free_port
    pid = fork do
      exec bin/"lightpanda", "serve", "--host", "127.0.0.1", "--port", port.to_s, "--log_level", "info"
    end

    begin
      sleep 5
      version_json = shell_output("curl -s http://127.0.0.1:#{port}/json/version")
      assert_match %r{"webSocketDebuggerUrl": "ws://127\.0\.0\.1:#{port}/"}, version_json
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
