class Container2wasm < Formula
  desc "Container to WASM converter"
  homepage "https://ktock.github.io/container2wasm-demo/"
  url "https://github.com/container2wasm/container2wasm/archive/refs/tags/v0.8.4.tar.gz"
  sha256 "4216e148c88588924f4026d8359be35f5c861967ab8e55a733bb879cdca678e8"
  license "Apache-2.0"
  head "https://github.com/container2wasm/container2wasm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "43a3920339e2ad9565d1f854ecdf5b558f00329c68dc947f452f5171db4e8d1c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "43a3920339e2ad9565d1f854ecdf5b558f00329c68dc947f452f5171db4e8d1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43a3920339e2ad9565d1f854ecdf5b558f00329c68dc947f452f5171db4e8d1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "04090ab1f4f27f389cc9a556da35e4738e8978e30032faa023e53378612bf281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4597892628f6343b93ff1bd8315f28f0aaa8f3efb1fc3b3a12f532bc37b17cc"
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
