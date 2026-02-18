class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.1.34.tar.gz"
  sha256 "8c2686b4d3890e90be2bb80326d93d1081ed4078deaae63b8d04be0e5dba1c75"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec28eabafddfce82103fce1e72e35ecb2491ee391a6173647b9e83315a3bb708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec28eabafddfce82103fce1e72e35ecb2491ee391a6173647b9e83315a3bb708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec28eabafddfce82103fce1e72e35ecb2491ee391a6173647b9e83315a3bb708"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f843132a79721196b37fd7a10f09190b76ae4c9588d3b13050e28ad4bd96a3c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a17ce0f8de25522a8e7d68ae4c9a80651e4b1ad1425e93da1df4092fd5e5d44"
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
