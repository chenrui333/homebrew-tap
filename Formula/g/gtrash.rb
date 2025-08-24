class Gtrash < Formula
  desc "Featureful Trash CLI manager: alternative to rm and trash-cli"
  homepage "https://github.com/umlx5h/gtrash"
  url "https://github.com/umlx5h/gtrash/archive/refs/tags/v0.0.6.tar.gz"
  sha256 "66003276073d9da03cbb4347a4b161f89c81f3706012b77c3e91a154c91f3586"
  license "MIT"
  head "https://github.com/umlx5h/gtrash.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77b8d62f9daedb94cca580326c150bac19a288cfeb6d7034db9edf8c5ad6bc6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06cdc9ef873ccc6cc66f4625a803ba51f6a6379e32968de3e9cd93a0f756de09"
    sha256 cellar: :any_skip_relocation, ventura:       "34cfc2ed5b067c9f64dbfac0ea80694c166f02f25a1f6886824cde6db44a555e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "562b8ffff4310f77b52d677dcb7a155f49ff9471025e6c182915095fea099c62"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601} -X main.builtBy=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gtrash", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtrash --version")
    system bin/"gtrash", "summary"
  end
end
