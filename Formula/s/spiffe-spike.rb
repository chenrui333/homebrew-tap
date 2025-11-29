class SpiffeSpike < Formula
  desc "Lightweight secrets store using SPIFFE as its identity control plane"
  homepage "https://spike.ist/"
  url "https://github.com/spiffe/spike/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "6cc31ed9b8b9890e83deb280065ed5d247562aab6b7e88e659bd66548ced5b4a"
  license "Apache-2.0"
  head "https://github.com/spiffe/spike.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "76bf9b2809bb37ed9ecbc6ccdb837482e9fecf53618a5cfaf361382f2a3a99b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "034094d8100c9f8028fe45b7fd9a0328f571f7e0532503713b7d7695de60f497"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7f19c6af226a08e0a0d660699c34f262afa517c280890ed91c11a05445569d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f093840d8fd4f63f970b448b8a727a8a921bfa623aaa7945866a4151c0dcfc2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "808ad5b7bec4bcc9da12dc9303bbb1bce8e41f6196e9fca6c1ba0d7c24df8ec7"
  end

  depends_on "go" => :build
  uses_from_macos "sqlite"

  def install
    # cgo for sqlite dependency
    ENV["CGO_ENABLED"] = "1"
    ENV["GOFIPS140"] = "v1.0.0"

    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

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
