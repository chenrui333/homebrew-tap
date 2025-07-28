class Container2wasm < Formula
  desc "Container to WASM converter"
  homepage "https://ktock.github.io/container2wasm-demo/"
  url "https://github.com/container2wasm/container2wasm/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "8e67b5e0d204ecf6ed2cf5e7abbd4dfe8e606568f1980193e5048aed0dd8c376"
  license "Apache-2.0"
  head "https://github.com/container2wasm/container2wasm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1fa16685129c1d814aa6f9b0805e40943a8cc3a13d88d0c88ab997287609fe9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81876d23e1ed8c7ebfc01b1a08c894799bb9c92d4050b6d81aaa5a43cc5e477d"
    sha256 cellar: :any_skip_relocation, ventura:       "3425dbb2caf5329c0a16e0237ea653e6bc2afdc504fa5572e01353c22df56341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44d12d9ce38281f4e60304831771e33e11524b0b13cf7a62160c7e081606f8d7"
  end

  depends_on "go" => :build

  def install
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
