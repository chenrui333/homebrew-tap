class Nocc < Formula
  desc "Distributed C++ compiler: like distcc, but faster"
  homepage "https://github.com/VKCOM/nocc"
  url "https://github.com/VKCOM/nocc/archive/refs/tags/v1.2.tar.gz"
  sha256 "075cb42bdd00e07b62879ada30ece3aaf860ca46203a033a0f9da344fd43eb59"
  license "MIT"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53ebb2b10953c39a5b09f7260d3bd6628be5358e7a41dbc8b05da4203de115f3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6dcc113305f2d789a338a1b767984e115c2111f7d984acc9334dc7a2a8c0d1db"
    sha256 cellar: :any,                 arm64_linux:   "34afc056f54a2d63d6d2b81aee13a53bca7bc8e25907870c8e5d9cf92d9a6101"
    sha256 cellar: :any,                 x86_64_linux:  "70db351620e81ac1f27cc4ce5f27cca906d5ab877e9d6e7984405954e8fa8d16"
  end

  depends_on "go" => :build

  # The test compiles via nocc-server over loopback gRPC and the daemon's unix socket.
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X github.com/VKCOM/nocc/internal/common.version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nocc-daemon"), "./cmd/nocc-daemon"
    system "go", "build", *std_go_args(ldflags:, output: bin/"nocc-server"), "./cmd/nocc-server"
    system ENV.cxx, "-std=c++11", "-O3", "cmd/nocc.cpp", "-o", bin/"nocc"
  end

  test do
    port = free_port
    ENV["NOCC_SERVERS"] = "127.0.0.1:#{port}"
    ENV["NOCC_GO_EXECUTABLE"] = bin/"nocc-daemon"

    %w[nocc nocc-server].each do |cmd|
      assert_match version.to_s, shell_output("#{bin}/#{cmd} --version")
    end

    (testpath/"test.cpp").write <<~CPP
      int main() { return 0; }
    CPP

    server_pid = spawn bin/"nocc-server", "-port", port.to_s
    sleep 2

    begin
      system bin/"nocc", ENV.cxx, testpath/"test.cpp", "-o", testpath/"test", "-c"
      assert_path_exists testpath/"test"
    ensure
      Process.kill("TERM", server_pid)
      Process.wait(server_pid)
    end
  end
end
