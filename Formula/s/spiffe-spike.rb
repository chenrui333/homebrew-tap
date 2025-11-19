class SpiffeSpike < Formula
  desc "Lightweight secrets store using SPIFFE as its identity control plane"
  homepage "https://spike.ist/"
  url "https://github.com/spiffe/spike/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "869c5f49532054623d5878780c75e66bf1b28d0c90efbfbfbde5eb1d41222102"
  license "Apache-2.0"
  head "https://github.com/spiffe/spike.git", branch: "main"

  depends_on "go" => :build
  uses_from_macos "sqlite"

  def install
    # cgo for sqlite dependency
    ENV["CGO_ENABLED"] = "1"
    ENV["GOFIPS140"] = "v1.0.0"

    %w[keeper nexus spike].each do |cmd|
      ldflags = "-s -w"
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./app/#{cmd}/cmd/main.go"
    end
  end

  test do
    output_log = testpath/"output.log"
    pid = spawn bin/"keeper", [:out, :err] => output_log.to_s
    sleep 1
    assert_match "SPIKE: Secure your secrets with SPIFFE", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
