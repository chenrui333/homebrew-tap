class Msgvault < Formula
  desc "Offline email archive with fast search and analytics"
  homepage "https://msgvault.io"
  url "https://github.com/wesm/msgvault/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "c51859c36619803a1fc9529ed03b69161ababc28ce32334e66d4e748ab4cfd02"
  license "MIT"
  head "https://github.com/wesm/msgvault.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f9f1b3da9ddfccbf19259c2907ef17709e6a6f2f6beed50b919df95bee96c12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "baff3340225c67261f87cbbaf320d53b7c8f6b7948ef4868131d1e624c8cb7f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3637cf040771f096fa8203aa62e9a5cfe03b6c0458606b6368288c86b3763a0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca473ffa4738480c307a31fd73e7cafd5e3e6ef99d0ee5e2c6c9442b7d7f5e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8afc238f94e359e6a0a7b4af6c4938ef494486038037a0851a283228d7359332"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.Version=#{version}
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.Commit=homebrew
      -X github.com/wesm/msgvault/cmd/msgvault/cmd.BuildDate=#{time.iso8601}
    ]

    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?
    system "go", "build", *std_go_args(ldflags:), "-tags", "fts5", "./cmd/msgvault"

    ENV["MSGVAULT_HOME"] = buildpath/".msgvault"
    generate_completions_from_executable(bin/"msgvault", "completion")
  end

  test do
    ENV["MSGVAULT_HOME"] = testpath.to_s

    assert_match version.to_s, shell_output("#{bin}/msgvault version")

    init_output = shell_output("#{bin}/msgvault init-db")
    assert_match "Database:", init_output
    assert_match "Messages:    0", init_output

    stats_output = shell_output("#{bin}/msgvault stats --local")
    assert_match "Accounts:    0", stats_output
  end
end
