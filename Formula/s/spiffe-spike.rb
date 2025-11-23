class SpiffeSpike < Formula
  desc "Lightweight secrets store using SPIFFE as its identity control plane"
  homepage "https://spike.ist/"
  url "https://github.com/spiffe/spike/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "649a3dd1df79f4f1952d93d65c73a070b946c74847e92be6287b1ec09cfa6a14"
  license "Apache-2.0"
  head "https://github.com/spiffe/spike.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88070e72195e8a59aa485585a37a8b9b49745d331b5281136fea459f2e0922b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "55252aafff9b5c7061defacaac15c18d02ffee74c167dfa86d44196b5648e6fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8296e12ac9d8dce771f0bc7fbf807a2d10916cc1f083b504e485481d2feb0b71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78e831986cd7d7b30f835697f4b17f101f72cebbcd0286b5fe21f7cfbab7ed52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c832d28e1ede5eb4b43c292b395008f699ce003fb78987b08b29bdd52d31d9a"
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
