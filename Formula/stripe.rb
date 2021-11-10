# frozen_string_literal: true

# code based on:
#   https://github.com/stripe/homebrew-stripe-cli/blob/master/stripe.rb
# extended to support both macOS and Linux

class Stripe < Formula
  desc "Stripe CLI utility"
  homepage "https://stripe.com"
  version "1.7.6"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/stripe/stripe-cli/releases/download/v1.7.8/stripe_1.7.8_mac-os_x86_64.tar.gz"
      sha256 "24431e694cf3a5a1323830356e78ae78085b536943d45b11487f6f4dce7e9af3"
    elsif Hardware::CPU.arm?
      url "https://github.com/stripe/stripe-cli/releases/download/v1.7.8/stripe_1.7.8_mac-os_arm64.tar.gz"
      sha256 "e1f1730bc47b21d5b7b2b91af721c3769192eec95f22f7df0d117452977bd46d"
    end
  elsif OS.linux? && Hardware::CPU.intel?
    url "https://github.com/stripe/stripe-cli/releases/download/v1.7.8/stripe_1.7.8_linux_x86_64.tar.gz"
    sha256 "d3367e7afbee6b40ddddfd7a1accfccf94f835863299a3102db8ef6beeb0e1a9"
  end

  def install
    bin.install "stripe"
    system bin/"stripe", "completion", "--shell", "bash"
    system bin/"stripe", "completion", "--shell", "zsh"
    bash_completion.install "stripe-completion.bash"
    zsh_completion.install "stripe-completion.zsh"
    (zsh_completion/"_stripe").write <<~EOS
      #compdef stripe
      _stripe () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/stripe-completion.zsh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      ❤ Thanks for installing the Stripe CLI! If this is your first time using the CLI, be sure to run `stripe login` first.
    EOS
  end

  test do
    system bin/"stripe", "--help"
  end
end
