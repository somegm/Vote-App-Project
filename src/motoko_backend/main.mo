import List "mo:base/List";
import Bool "mo:base/Bool";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Int "mo:base/Int";

actor selection {

    type Voter = {
      id: Nat; 
      name: Text;
      created_at: Int;
    };
    var voters : List.List<Voter> = List.tabulate<Voter>(5, func(i : Nat) : Voter {
    switch (i) {
        case 0 { return {id=1; name="Ahmet Mehmet"; created_at=12345657}; };
        case 1 { return {id=2; name="Hasan Fatih"; created_at=12345657}; };
        case 2 { return {id=3; name="Ayşe Fatma"; created_at=12345657}; };
        case 3 { return {id=4; name="Ekrem Murat"; created_at=12345657}; };
        case _ { return {id=5; name="Ferdi Mahmut"; created_at=12345657}; };
      };
    });

    public func add_voter(id: Nat, name: Text, created_at: Int): async Voter {
      let new_voter: Voter = {
        id = id;
        name = name;
        created_at = created_at;
      };
      voters := List.push(new_voter, voters);
      return new_voter;
    };

    public func get_voters() : async List.List<Voter> {
        return voters;
    };

    // Kimliğe dayalı seçmen bilgilerini alma işlevi
    public func get_voter_by_id(voter_id: Nat) : async ?Voter {
        return List.find<Voter>(voters, func (v: Voter) : Bool { v.id == voter_id });
    };

    // Aday
    public type Candidate = {
        id: Nat;
        name: Text;
        category: Text;
    };

    // Örnek adayları başlatma yeri
    var candidates: List.List<Candidate> = List.tabulate<Candidate>(3, func(i : Nat) : Candidate {
    switch (i) {
        case 0 { return {id=1; name="Cat"; category="Pet"}; };
        case 1 { return {id=2; name="Dog"; category="Pet"}; };
        case _ { return {id=3; name="Bird"; category="Pet"}; };
      };
    });

    public func get_candidates() : async List.List<Candidate> {
        return candidates;
    };

    public func get_candidate_by_category(category: Text) : async List.List<Candidate> {
        return List.filter<Candidate>(candidates, func (v: Candidate) : Bool { v.category == category });
    };

    // Oy Kısmı
    public type Vote = {
      id: Nat;
      candidate_id: Nat;
      category: Text;
    };

    public func voting_result() : async List.List<Vote> {
        return votes;
    };
    var votes: List.List<Vote> = List.nil<Vote>();


    public func get_vote_by_id(voter_id: Nat) : async ?Vote {
        return List.find<Vote>(votes, func (v: Vote) : Bool { v.id == voter_id });
    };
    public func commit_vote(voterId: Nat, candidate_id: Nat, category: Text): async Bool {
        let isEligVoter = List.filter(voters, func(v: Voter): Bool {
            v.id == voterId;
        });

        let isNotVoted = List.filter(votes, func(v: Vote): Bool {
            v.id == voterId;
        });

         // Gereksinimleri karşılıyosa oy kullanma yeri
        if (List.size(isEligVoter) > 0 and List.size(isNotVoted) == 0) {

            // oy kullanma listesine ekleme
            let new_vote: Vote = {
              id = voterId;
              candidate_id = candidate_id;
              category = category;
              
            };
            votes := List.push(new_vote, votes);
            return true; // Başarılı olma kısmı
        } else {
            return false; // Başarısız olma kısmı
        }
    }
};
