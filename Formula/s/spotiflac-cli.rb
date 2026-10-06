class SpotiflacCli < Formula
  desc "Spotify downloader with playlist sync in mind"
  homepage "https://github.com/Superredstone/spotiflac-cli"
  url "https://github.com/Superredstone/spotiflac-cli/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f79863279d61978ddc1f2dc3b8214c017aaf49b06c37ff315858c1c98d355e9c"
  license "MIT"
  head "https://github.com/Superredstone/spotiflac-cli.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d482736f979ca01f1d5b7a428abec12e630792e6ae999edea3e49278cbdb409"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d482736f979ca01f1d5b7a428abec12e630792e6ae999edea3e49278cbdb409"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1daa27c740b8eef1131016a2de0a1f5b2ff2c3c9a77d150d15be04e72ec22775"
    sha256 cellar: :any,                 x86_64_linux:  "4fe2367643b050febdc78ad3da328d9f90e4b9c38f9f38fe7676101924803378"
  end

  depends_on "go" => :build
  depends_on "ffmpeg"

  resource "spotiflac-backend" do
    url "https://github.com/afkarxyz/SpotiFLAC/archive/refs/tags/v7.0.9.tar.gz"
    sha256 "61bd2ec5590ad28c0c7f933d1e189d71fba7f596ca523e14d477e43e0e4afbb1"
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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
    # FIXME: Upstream does not expose a version command; replace this with a version assertion when available.
    assert_match "Invalid URL.", shell_output("#{bin}/spotiflac-cli download 2>&1", 1)
  end
end
