class Splashboard < Formula
  desc "Customizable terminal splash screen with plugin-based data sources"
  homepage "https://github.com/unhappychoice/splashboard"
  url "https://github.com/unhappychoice/splashboard/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "e00c67f429d58f36975d933114b6f083e9d4640b7348641ae8e0678987a8de51"
  license "ISC"
  head "https://github.com/unhappychoice/splashboard.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "897378a365704b3c8a887fcd2de2b5f8c87dd1bb8acb24d515a3890f8b203e8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66b08f33648f4346e9e1956ce2626308cbf35d16654d4a55c3e1ae7449946fd9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58c37565e1b0c398ef4afde4629a76ba7f651ee8a907ed61b82b45722fc2314c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "836db07557e76bbde44c754659c594ab7ec0fa13bcc53c523c89cdc702ed1eb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fa78fcb126bf1e6a6f422ab40a3d713bd6d339a0419d036c464e9fa4794f277"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splashboard --version 2>&1")
  end
end
