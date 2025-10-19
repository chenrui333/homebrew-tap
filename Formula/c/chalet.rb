class Chalet < Formula
  desc "Containerize your dev environments"
  homepage "https://github.com/chalet-dev/chalet"
  url "https://github.com/chalet-dev/chalet/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "df98043f4258d9a55e6dd41f2e9a8a302cbc7740974ae77fe43926953bea223c"
  license "MIT"
  revision 1
  head "https://github.com/chalet-dev/chalet.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45cbdb926ad98cf68885a2c14de01ed11042d73503d8bca2307632a355eee2e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45cbdb926ad98cf68885a2c14de01ed11042d73503d8bca2307632a355eee2e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45cbdb926ad98cf68885a2c14de01ed11042d73503d8bca2307632a355eee2e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4dffe36d427ddd52fd0c3342ec13c99cd8d699fcb48e8ef7282bf9745665c805"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b03a91d51820cabb32da673866fecb14ebfc0526da38a278f24f4db7523b391"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    system bin/"chalet", "init"

    output = shell_output("#{bin}/chalet run")
    assert_match "Error opening YAML file", output
  end
end
