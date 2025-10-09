class Container2wasm < Formula
  desc "Container to WASM converter"
  homepage "https://ktock.github.io/container2wasm-demo/"
  url "https://github.com/container2wasm/container2wasm/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "8e67b5e0d204ecf6ed2cf5e7abbd4dfe8e606568f1980193e5048aed0dd8c376"
  license "Apache-2.0"
  revision 1
  head "https://github.com/container2wasm/container2wasm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f67b555cd1c8ecab46767c3c2f4ec8f513c77de38952535df2864e30c832074"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f67b555cd1c8ecab46767c3c2f4ec8f513c77de38952535df2864e30c832074"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f67b555cd1c8ecab46767c3c2f4ec8f513c77de38952535df2864e30c832074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dbbdc64d10758c7599abaa7a44fad1d11305ff7f4c490bf458c9cbf10899be52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5f79a0396926008a15bd4ace5094bdf6549b11063014377684463eb56362530"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

    ldflags = %W[
      -s -w
      -X github.com/ktock/container2wasm/version.Version=#{version}
    ]

    %w[c2w c2w-net].each do |cmd|
      system "go", "build", *std_go_args(ldflags:, output: bin/cmd), "./cmd/#{cmd}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/c2w --version")
    assert_match "FROM wasi-$TARGETARCH", shell_output("#{bin}/c2w --show-dockerfile")
  end
end
