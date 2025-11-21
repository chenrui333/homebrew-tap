class Cozypkg < Formula
  desc "Cozy wrapper around Helm and Flux CD for local development"
  homepage "https://github.com/cozystack/cozypkg"
  url "https://github.com/cozystack/cozypkg/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "0efa5aa54d3875a586b214c3aad00433a788694bd718c5cfd84fd23c61420d2c"
  license "Apache-2.0"
  head "https://github.com/cozystack/cozypkg.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d832a106205cd49171cff789d96ad937a1ac60581a02f993917e56632a7a2053"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1324999ab50221cb460c0ba7a5dbce33ccf6ee2ac3d1c9588a0751a68ec7e3fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae44bd6d5257d089c37f6bc9f78b57e30a504ef6eb2b6e4ac06fe52bfdd06283"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7edc7bfb1e836dddfd4c6bd913b22d75dce4ace467e3ac03d09cdd8b18d5191a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1637ada418e8081f48b76f6695099d91aa837b5fccdd0fcd82ad6ba2cbe93280"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}")

    generate_completions_from_executable(bin/"cozypkg", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cozypkg --version")

    output = shell_output("#{bin}/cozypkg list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output
  end
end
