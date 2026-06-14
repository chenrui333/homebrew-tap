class Redli < Formula
  desc "Humane alternative to redis-cli with TLS support"
  homepage "https://github.com/IBM-Cloud/redli"
  url "https://github.com/IBM-Cloud/redli/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "a75de85b90466a088e39885b67c38cb3e7ceeee6f1ec82df3d1d88aee5a17a20"
  license "Apache-2.0"
  head "https://github.com/IBM-Cloud/redli.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7496f1fdd5a768e5f012cb13ff33c6db37df099ace3c5986a136757f76c32390"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7496f1fdd5a768e5f012cb13ff33c6db37df099ace3c5986a136757f76c32390"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7496f1fdd5a768e5f012cb13ff33c6db37df099ace3c5986a136757f76c32390"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ae7516b630687e5b756a2e0cebb3cf61b20737c6426f39d1d399e939f518a69"
    sha256 cellar: :any,                 x86_64_linux:  "baa71dd17c8407295b9a19ef034395c396e7108e31eefb7f9f83b0845f3da111"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/redli --version 2>&1")

    output = shell_output("#{bin}/redli --debug --uri redis://localhost:1 2>&1", 1)
    assert_match "connection refused", output
  end
end
