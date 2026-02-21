class SpotiflacCli < Formula
  desc "Spotify downloader with playlist sync in mind"
  homepage "https://github.com/Superredstone/spotiflac-cli"
  url "https://github.com/Superredstone/spotiflac-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f79863279d61978ddc1f2dc3b8214c017aaf49b06c37ff315858c1c98d355e9c"
  license "MIT"
  head "https://github.com/Superredstone/spotiflac-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a682efb063603a3a28ffc2f44949f5fdeeb85ab44d25785b9261e572e9ecbe99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a682efb063603a3a28ffc2f44949f5fdeeb85ab44d25785b9261e572e9ecbe99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a682efb063603a3a28ffc2f44949f5fdeeb85ab44d25785b9261e572e9ecbe99"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "289f46ec05476ebdc340569f40d90ff2dbf172759cf173f7a76a535de6dda88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d321bd7baec62a2e00d885221b53115226d911a6cad033a466e3d2fbc37b70"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"

  resource "spotiflac-backend" do
    url "https://github.com/afkarxyz/SpotiFLAC/archive/refs/tags/v7.0.9.tar.gz"
    sha256 "61bd2ec5590ad28c0c7f933d1e189d71fba7f596ca523e14d477e43e0e4afbb1"
  end

  def install
    resource("spotiflac-backend").stage(buildpath/"SpotiFLAC")

    rm_r "lib", force: true
    rm_r "app", force: true

    cp_r "SpotiFLAC/backend", "lib"
    (buildpath/"app").mkpath
    cp "SpotiFLAC/app.go", "app/app.go"

    inreplace "app/app.go", "package main", "package app"
    inreplace "app/app.go", '"spotiflac/backend"', 'backend "github.com/Superredstone/spotiflac-cli/lib"'
    Dir["lib/*.go"].each do |file|
      inreplace file, "package backend", "package lib"
    end

    system "go", "build", *std_go_args
  end

  test do
    assert_match "Spotify downloader with playlist sync in mind.", shell_output("#{bin}/spotiflac-cli --help")
    assert_match "Invalid URL.", shell_output("#{bin}/spotiflac-cli download 2>&1", 1)
  end
end
