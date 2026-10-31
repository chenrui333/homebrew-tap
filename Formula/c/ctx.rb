class Ctx < Formula
  desc "Search the coding agent history already on your machine"
  homepage "https://github.com/ctxrs/ctx"
  url "https://github.com/ctxrs/ctx/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "0204ab04e5ec2d3ead16f46a4993945691b4293461e37d937a0a1d494dc31760"
  license "Apache-2.0"
  head "https://github.com/ctxrs/ctx.git", branch: "main"

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "onnxruntime" => :no_linkage
  depends_on "xz"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # The daemon is part of ctx itself, not a separately installed helper.
    system "cargo", "install", *std_cargo_args(path: "crates/ctx-cli", root: libexec)
    # Keep semantic search available using the packaged native library rather
    # than requiring an upstream compiled ONNX Runtime sidecar.
    (bin/"ctx").write <<~SH
      #!/bin/sh
      export CTX_ONNXRUNTIME_DIR="${CTX_ONNXRUNTIME_DIR:-#{formula_opt_lib("onnxruntime")}}"
      exec "#{libexec}/bin/ctx" "$@"
    SH
    chmod 0755, bin/"ctx"
    (pkgshare/"skills").install "skills/ctx"
  end

  service do
    run [opt_bin/"ctx", "daemon", "run"]
    keep_alive true
    log_path var/"log/ctx.log"
    error_log_path var/"log/ctx.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctx --version")

    ENV["CTX_DATA_ROOT"] = (testpath/"history").to_s
    status = JSON.parse(shell_output("#{bin}/ctx status --format=json"))
    assert_equal false, status.fetch("initialized")
    refute_path_exists testpath/"history"
  end
end
