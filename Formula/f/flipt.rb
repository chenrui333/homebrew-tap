class Flipt < Formula
  desc "Enterprise-ready, Git native feature management solution"
  homepage "https://flipt.io/"
  url "https://github.com/flipt-io/flipt/archive/refs/tags/v2.13.1.tar.gz"
  sha256 "d4978f183bc9449daa4d45b6cccd9b95081f84261c8e437357be3a99fd772518"
  # Fair Core License, Version 1.0, with a future MIT license.
  license :cannot_represent
  head "https://github.com/flipt-io/flipt.git", branch: "v2"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d5dc4c1b5b102168cfd3d8749de2529fbe29dee0b5734c1cc05a77ea40c9cdca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "033374f400c165b0e23d393cdfd14574be4ccf08ce64be928f46061e67c0f3aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dddb21476905bc98d007d86264ee25841f86eab6e7cfb7f4770014598362704c"
    sha256 cellar: :any,                 x86_64_linux:  "043b37879091f7491d35fc19a748685fb55f8ab0a164a0cb2aac61f00a5252a6"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/flipt"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flipt --version")

    cfg = testpath/"config.yml"
    system bin/"flipt", "config", "init", "--force", "--config", cfg
    assert_match "storage:\n  default:\n    backend:\n      type: memory", cfg.read
  end
end
