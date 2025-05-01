class Container2wasm < Formula
  desc "Container to WASM converter"
  homepage "https://ktock.github.io/container2wasm-demo/"
  url "https://github.com/container2wasm/container2wasm/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "046e29b9dcb0fc8fc3bca8a5b0534b5f3a71c60bd5e1801cd2edf5cf914e511a"
  license "Apache-2.0"
  head "https://github.com/container2wasm/container2wasm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "241d20c5ea0ac937543be6003ebedf859b941e75d3d29c74737ae65cbfdb11f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4281e32637959a0d7e7743c794f9da9e62314b70b8b0a32ba1214842a3c251a"
    sha256 cellar: :any_skip_relocation, ventura:       "74985cca0985f7a90ce78006cd37a13bdc50601470523a28499d70207a35e646"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ea44b570387a3ce7e9f71637a4929aff6bfbd7e165314a827f1358e1ce13e72"
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
