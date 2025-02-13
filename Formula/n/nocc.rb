class Nocc < Formula
  desc "Distributed C++ compiler: like distcc, but faster"
  homepage "https://github.com/VKCOM/nocc"
  url "https://github.com/VKCOM/nocc/archive/refs/tags/v1.2.tar.gz"
  sha256 "075cb42bdd00e07b62879ada30ece3aaf860ca46203a033a0f9da344fd43eb59"
  license "MIT"

  depends_on "go" => :build

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
