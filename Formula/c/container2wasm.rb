class Container2wasm < Formula
  desc "Container to WASM converter"
  homepage "https://ktock.github.io/container2wasm-demo/"
  url "https://github.com/container2wasm/container2wasm/archive/refs/tags/v0.8.3.tar.gz"
  sha256 "8e67b5e0d204ecf6ed2cf5e7abbd4dfe8e606568f1980193e5048aed0dd8c376"
  license "Apache-2.0"
  head "https://github.com/container2wasm/container2wasm.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "938f945bc41f561407356285bab78b3ab7e25ccfda551f562a36f8038d02d757"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88e1c0a78ba3e0efa62e5858c382577189cf87263c81cec2cc4b4fc090db2cb0"
    sha256 cellar: :any_skip_relocation, ventura:       "147aaa9b59ca16754559f501576bd59fc765d95d18a1cfcdb1217d8f232553de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7ccf76c44a2ddbd2a3a1d234e482cc5c63e1a72284d33a074d1724270f3a6d00"
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
