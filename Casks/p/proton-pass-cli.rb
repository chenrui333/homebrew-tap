cask "proton-pass-cli" do
  arch arm: "aarch64", intel: "x86_64"
  os macos: "macos", linux: "linux"

  version "2.1.2"
  sha256 arm:          "2ae5bdf202f67e4b7f7886ddba44d267242fcd35ccb861a61acf860235de2250",
         intel:        "5d902d825cbde5d00034ae06e1529429e389decb0891d8604fd46b0fb0c67500",
         arm64_linux:  "0562625812f940bd4b7abd664b3bbcfefdeaf79d2f9b12f2d0a73be1ffc551ff",
         x86_64_linux: "5291edd21d85d222538b91341345ae3b0a1479e254d42920c2bbbd34012c6243"

  url "https://proton.me/download/pass-cli/#{version}/pass-cli-#{os}-#{arch}",
      verified: "proton.me/"
  name "Proton Pass CLI"
  desc "Command-line interface for Proton Pass"
  homepage "https://protonpass.github.io/pass-cli/"

  livecheck do
    url "https://proton.me/download/pass-cli/versions.json"
    strategy :json do |json|
      json["passCliVersions"]["version"]
    end
  end

  binary "pass-cli-#{os}-#{arch}", target: "pass-cli"

  zap trash: [
    "~/.local/share/proton-pass-cli",
    "~/.ssh/proton-pass-agent.*",
    "~/Library/Application Support/proton-pass-cli",
  ]
end
