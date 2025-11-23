class SpiffeSpike < Formula
  desc "Lightweight secrets store using SPIFFE as its identity control plane"
  homepage "https://spike.ist/"
  url "https://github.com/spiffe/spike/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "649a3dd1df79f4f1952d93d65c73a070b946c74847e92be6287b1ec09cfa6a14"
  license "Apache-2.0"
  head "https://github.com/spiffe/spike.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "399987b12064686b81a71fdfb2a11c1ba5617a752430ca6d3e105561eee0248f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5a36422414eaa99b1ba0f1e3f36bed70eac358f0d8de7fd54d7ac4c6ac2ea8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe7c790d2cfff9f85d9eabf50145636ee87493d5e07475eaaaa6712a05284edb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23ec523b1216cb184c7797c26750b074d372fa397fbf4f2552a59ea173619f9d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9466e87f70a90c98362ca244a5b883eb4e579cd5008c00f0ace97d409bec657"
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
