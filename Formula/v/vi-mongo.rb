class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.1.33.tar.gz"
  sha256 "10f44d6495552f154aa99a144e8c57147c1e86604748e6916e2cf7ba8637fac3"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa431b7ce33460a37e26ac0e2e8284703caaa5f0483e2e8ac53abe8e1d5f2b25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa431b7ce33460a37e26ac0e2e8284703caaa5f0483e2e8ac53abe8e1d5f2b25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fa431b7ce33460a37e26ac0e2e8284703caaa5f0483e2e8ac53abe8e1d5f2b25"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cba5341a8dfd3332d8ae729a47d2dd30bb5922fd0d14cf6719c6bb2933755075"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e992fbe1ae0d4052b3ddea446d35900acc31f590e55ae5a24ea63386c757798c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kopecmaciej/vi-mongo/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vi-mongo --version")
    assert_match "No connections available", shell_output("#{bin}/vi-mongo --connection-list")
  end
end
